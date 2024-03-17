defmodule SpcData do
  @moduledoc """
  This is a contrived demo app that reads SPC data from a piece of equipment on a fab floor. The app uses Broadway Kafka to ingest the SPC values and save them to a database for future processing.

  This particular module defines our Kafka Producer.
  """
  use Broadway
  require Logger

  alias Broadway.Message
  alias SpcData.Repo
  alias SpcData.Reading

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: Application.fetch_env!(:spc_data, :producer_module),
        concurrency: 1
      ],
      processors: [
        default: [
          concurrency: 10
        ]
      ],
      batchers: [
        default: [
          batch_size: 100,
          batch_timeout: 200,
          concurrency: 10
        ]
      ]
    )
  end


  # https://hexdocs.pm/broadway/apache-kafka.html#implement-broadway-callbacks
  @impl true
  def handle_message(_, %Message{} = message, _) do
    message =
      Message.update_data(message, fn data ->
        case String.split(data, ", ") do
          [id | values] ->
            # returns list of readings maps
            build_readings_list(id, values)
          _ ->
            data
        end
      end)

    if is_binary(message.data) do
      # Move the message to a batcher of errors.
      Message.put_batcher(message, :parse_err)
    else
      message
    end
  end

  defp build_readings_list(id, values) do
    values
    |> Enum.reduce(
        [],
        fn value, acc ->
          [
            %{
              equipment_id: id |> String.to_integer(),
              value: value |> String.to_float(),
              inserted_at: DateTime.utc_now
            } 
            | acc
          ]
      end
    )
  end

  # messages is a list of readings maps
  @impl true
  def handle_batch(:default, messages, _, _) do
    for readings <- messages do
      {rows, _} = Repo.insert_all(Reading, readings.data)
      Logger.debug("saved rows: #{rows}")
    end
    messages
  end

  def handle_batch(:parse_err, messages, _, _) do
    Logger.info("in parse error batcher")
    Logger.info(fn -> "size: #{length(messages)}" end)
    Logger.info("the following messages with errors will be dropped")

    Enum.map(messages, &Logger.info("message: #{inspect(&1.data)}"))

    messages
  end

end

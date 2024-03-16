defmodule SpcData do
  @moduledoc """
  This is a contrived demo app that reads SPC data from a piece of equipment on a fab floor. The app uses Broadway Kafka to ingest the SPC values and save them to a database for future processing.

  This particular module defines our Kafka Producer.
  """
  use Broadway

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {BroadwayKafka.Producer, [
          hosts: [localhost: 9092],
          group_id: "group_1",
          topics: ["spc-data"],
        ]},
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

  # first, we update the message's data individually 
  # inside handle_message/3
  @impl true
  def handle_message(_, message, _) do
    IO.inspect(message.data, label: "Got message")
    message
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    list = messages |> Enum.map(fn e -> e.data end)
    IO.inspect(list, label: "Got batch")
    messages
  end
end

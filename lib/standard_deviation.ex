defmodule StandardDeviation do
  import Enum, only: [sum: 1]
  import :math, only: [sqrt: 1, pow: 2]
  import Ecto.Query, warn: false

  def equipment_stats(equipment_id) do
    [readings, e_name] = get_readings(equipment_id)
    mn = mean(readings)
    sd = standard_deviation(readings)

    IO.puts "SPC Results for #{e_name}:"
    IO.puts " → mean: #{mn}"
    IO.puts " → standard deviation: #{sd}"
  end

  defp standard_deviation(data) do
    m = mean(data)
    data |> variance(m) |> mean |> sqrt
  end

  defp mean(data) do
    sum(data) / length(data)
  end

  defp variance(data, mean) do
    for n <- data, do: pow(n - mean, 2)
  end

  defp get_readings(equipment_id) do
    query =
      from(
          r in SpcData.Reading,
          where: r.equipment_id == ^equipment_id,
          preload: :equipment
        )
    readings = SpcData.Repo.all(query)

    spc_data =
      readings
      |> Enum.map(&(&1.value))

    reading = readings |> Enum.at(0)

    [
      spc_data, 
      reading.equipment.model
    ]
  end
end
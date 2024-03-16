# simple test - https://hexdocs.pm/brod/brod.html#produce/5
topic = "spc-data"
client_id = :kafka_client
hosts = [localhost: 9092]

:ok = :brod.start_client(hosts, client_id, _client_config=[])
:ok = :brod.start_producer(client_id, topic, _producer_config = [])

Enum.each(1..1000, fn i ->
  spc_data = [
    i |> to_string,
    "#{:rand.uniform() * 10 |> Float.round(2)}, #{:rand.uniform() * 10 |> Float.round(2)}, #{:rand.uniform() * 10 |> Float.round(2)}, #{:rand.uniform() * 10 |> Float.round(2)}, #{:rand.uniform() * 10 |> Float.round(2)}, #{:rand.uniform() * 10 |> Float.round(2)}"
  ]
  :ok = :brod.produce_sync(client_id, topic, 0, _key="", spc_data |> List.to_string)
end)

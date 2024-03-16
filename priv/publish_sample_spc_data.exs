# simple test - https://hexdocs.pm/brod/brod.html#produce/5
topic = "spc-data"
client_id = :kafka_client
hosts = [localhost: 9092]

:ok = :brod.start_client(hosts, client_id, _client_config=[])
:ok = :brod.start_producer(client_id, topic, _producer_config = [])

:ok = :brod.produce_sync(client_id, topic, 0, _key="", "1")
# :ok
# Got message: "1"
:ok = :brod.produce_sync(client_id, topic, 0, _key="", "2")
# :ok
# Got message: "2"

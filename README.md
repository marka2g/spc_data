# SpcData

In my dev environment, I took the quick setup route and used [`asdf kafka`](https://github.com/ueisele/asdf-kafka) for my local setup. The first sections commands are specific to an `asdf` install - adjust the commands to suit you setup.

## Setup/Startup
After [installing kafka](https://kafka.apache.org/quickstart):
1. in a new terminal, start `zookeeper`
>→ $ `zookeeper-server-start $(asdf where kafka)/config/zookeeper.properties`
2. in a separate terminal, start the Kafka server
>→ $ `kafka-server-start $(asdf where kafka)/config/server.properties`
3. create our Kafka topic
>→ $ `kafka-topics --create --topic spc-data --bootstrap-server localhost:9092`
4. clone the project, `cd` into root and seed Kafka with dummy spc data
>→ $ `mix run --no-halt priv/publish_sample_spc_data.exs`


<!-- 
  read messages:

  kafka-console-consumer --topic spc-data-two --from-beginning --bootstrap-server localhost:9092
-->
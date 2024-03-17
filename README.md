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
>→ $ `mix run priv/repo/seeds.exs` to set up dummy equipment
>→ $ `mix run --no-halt priv/publish_sample_spc_data.exs` to add dummy spc data to Kafka topic

## How the App works
> The video below is a ~ 2min run-thru of how to add dummy spc data the Kafka topic and the query the db for spc data results
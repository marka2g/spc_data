# SpcData
This is a small app used to demonstrate how to build a multi-staged data processing pipeline with Elixir using the official [Broadway Kafka](https://hexdocs.pm/broadway/apache-kafka.html#content) library.
The write up lives [here](https://marksmarkdown.com/broadway_kafka.html)

**NOTE:**
In my dev environment, I took the quick setup route and used [`asdf-kafka`](https://github.com/ueisele/asdf-kafka) for my local setup. The first section's commands are specific to an `asdf` install - adjust the commands to suit your setup.

## Kafka Setup/Startup
After [installing kafka](https://kafka.apache.org/quickstart):
1. in a new terminal, start `zookeeper`
>→ $ `zookeeper-server-start $(asdf where kafka)/config/zookeeper.properties`
2. in a separate terminal, start the Kafka server
>→ $ `kafka-server-start $(asdf where kafka)/config/server.properties`
3. create our Kafka topic
>→ $ `kafka-topics --create --topic spc-data --bootstrap-server localhost:9092`

## The App Setup/Startup
1. clone the project, `cd` into root and seed dummy equipment in the application db
>→ $ `mix run priv/repo/seeds.exs`
2. Add dummy SPC event data the the Kafka topic from the script
>→ $ `mix run --no-halt priv/publish_sample_spc_data.exs`
3. Or, you can add data manually by starting up an `iex` repl. ..._passing the `--dbg` flag(optional) used when debugging with `dbg()`_
>→ $ `iex --dbg pry -S mix`
   >→ and add data the the Kafka topic with `:brod`, _example_
>>```elixir
>># first, check that there are equipment records from seeding the db
>>iex> Repo.aggregate(Equipment, :count, :id) # 1000
>>
>># then, simulate data being streamed to the Kafka topic
>>iex> :ok = :brod.start_client([localhost: 9092], :kafka_client, _client_config=[])
>>iex> :ok = :brod.start_producer(:kafka_client, "spc-data", _producer_config = [])
>>iex> 
>>Enum.each(1..1000, fn i ->
>>  spc_data = "#{i}, #{:rand.uniform() * 10 |> Float.round(2)}, #{:rand.uniform() * 10 |> Float.round(2)}, #{:rand.uniform() * 10 |> Float.round(2)}, #{:rand.uniform() * 10 |> Float.round(2)}, #{:rand.uniform() * 10 |> Float.round(2)}, #{:rand.uniform() * 10 |> Float.round(2)}"
>>
>>  :ok = :brod.produce_sync(:kafka_client, "spc-data", 0, _key="", spc_data)
>>end)
>>```
4. Finally, check the data in `iex`
>→ If all the streamed data successfully persisted into the application's database, you should have `6000` SPC data points in the `readings` table
>>```elixir
>># count the readings table
>>iex> Repo.aggregate(Reading, :count, :id) # 6000
>># check a random piece of equipment
>>iex> StandardDeviation.equipment_stats(300)
>> #=> SPC Results for Equipment # 300:
>>    #=> → mean: 5.0249999999999995
>>    #=> → standard deviation: 2.632975186615577 
>>```


## How the App Works
> The video below is a ~2min run-thru of how to add dummy spc data the Kafka topic and the query the db for spc data results

https://github.com/marka2g/spc_data/assets/12756/af4539bd-517b-4801-9d06-8bd49eb5a2f6



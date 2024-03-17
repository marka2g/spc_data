import Config

config :spc_data,
  ecto_repos: [SpcData.Repo]

config :spc_data, SpcData.Repo,
  database: "spc_data_repo",
  username: "marksadegi",
  password: "",
  hostname: "localhost",
  migration_timestamps: [type: :utc_datetime_usec]


config :spc_data,
  producer_module: {BroadwayKafka.Producer, [
    hosts: [localhost: 9092],
    group_id: "group_1",
    topics: ["spc-data"],
  ]
}
  
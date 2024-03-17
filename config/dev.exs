import Config

# Configure your database
config :spc_data, SpcData.Repo,
  username: "marksadegi",
  password: "",
  database: "spc_data_dev",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :logger, level: :debug

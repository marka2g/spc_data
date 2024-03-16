import Config
config :spc_data, producer_module: {Broadway.DummyProducer, []}

config :logger, backends: []
defmodule SpcData.Repo do
  use Ecto.Repo,
    otp_app: :spc_data,
    adapter: Ecto.Adapters.Postgres
end

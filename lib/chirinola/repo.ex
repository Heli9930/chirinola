defmodule Chirinola.Repo do
  use Ecto.Repo,
    otp_app: :chirinola,
    adapter: Ecto.Adapters.Postgres
end

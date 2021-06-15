defmodule Livedocs.Repo do
  use Ecto.Repo,
    otp_app: :livedocs,
    adapter: Ecto.Adapters.Postgres
end

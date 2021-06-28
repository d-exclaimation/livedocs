import Config

config :livedocs, Livedocs.Repo,
  database: "livedocs_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :livedocs,
  ecto_repos: [Livedocs.Repo],
  generators: [binary_id: true]

import_config("#{Mix.env()}.exs")

use Mix.Config

config :livedocs, Livedocs.Repo,
  ssl: true,
  url: System.get_env("DATABASE_URL", "postgres://127.0.0.1:5432/livedocs_repo?sslmode=disable"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

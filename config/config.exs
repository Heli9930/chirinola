import Config

config :chirinola, ecto_repos: [Chirinola.Repo]

config :chirinola, Chirinola.Repo,
  database: "chirinola",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :logger, level: :info

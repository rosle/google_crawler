use Mix.Config

# Configure your database
config :google_crawler, GoogleCrawler.Repo,
  username: "postgres",
  password: "postgres",
  database: "google_crawler_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :google_crawler, GoogleCrawlerWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

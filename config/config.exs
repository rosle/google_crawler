# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :google_crawler,
  ecto_repos: [GoogleCrawler.Repo]

# Configures the endpoint
config :google_crawler, GoogleCrawlerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OKDoLC3fMlPM/vLbeeW/SV6pNTMrieWMcqqHiafzZSj0YRP2r2+e3mz9XGgZ1DOU",
  render_errors: [view: GoogleCrawlerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: GoogleCrawler.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "7PRdGFq8"]

config :google_crawler, :google_api_client, GoogleCrawler.Google.ApiClient

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

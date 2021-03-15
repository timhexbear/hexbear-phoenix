# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :hexbear, Hexbear.Repo,
  adapter: Ecto.Adapters.Postgres,
  types: Hierarch.Postgrex.Types

config :hexbear,
  ecto_repos: [Hexbear.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :hexbear, HexbearWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "L0K/StcZsskTlNNeCCKTVCG1lbqaGoG/vh6hooPalomNqXBhsCkhpqqTSGhYjJ0t",
  render_errors: [view: HexbearWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Hexbear.PubSub,
  live_view: [signing_salt: "CK25QCDq"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

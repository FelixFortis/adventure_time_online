# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :adventure_time_online, AdventureTimeOnlineWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "RiGfQWT85OjCjpN2SqniAoZzkv7TbL//JfAluwxTShaHUN86fwCCMf9JxxoO3urr",
  render_errors: [view: AdventureTimeOnlineWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: AdventureTimeOnline.PubSub,
  live_view: [signing_salt: "qrh9tyJa"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

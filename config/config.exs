# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :cookpod,
  ecto_repos: [Cookpod.Repo]

# Configures the endpoint
config :cookpod, CookpodWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Ejqch35IQCATqz5oXjFolUqqyiXxEgPgLxd2Bgm/FQ34qAxHQuHgyJ4oENkcVPt5",
  render_errors: [view: CookpodWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Cookpod.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "d15X4uB4"]

config :cookpod,
  basic_auth: [
    username: "user",
    password: "123456",
    realm: "BASIC_AUTH_REALM"
  ]

config :cookpod, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: CookpodWeb.Router,
      endpoint: CookpodWeb.Endpoint
    ]
  }

config :phoenix_swagger, json_library: Jason

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ex_aws, json_codec: Jason

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine,
  slimleex: PhoenixSlime.LiveViewEngine

config :arc,
  storage: Arc.Storage.Local

config :cookpod, CookpodWeb.Gettext, locales: ~w(en ru), default_locale: "ru"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

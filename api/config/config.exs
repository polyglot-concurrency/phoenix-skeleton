import Config

## Configures the endpoint
#config :api, ApiWeb.Endpoint,
#  url: [host: "localhost"],
#  secret_key_base: "TlKin4OmcL+wnLOasc7pzD6qkw9ROvpG0g4LwJIoTcWsLo0XiGw8BQaT58AnrbEk",
#  render_errors: [view: ApiWeb.ErrorView, accepts: ~w(json)],
#  pubsub: [name: Api.PubSub, adapter: Phoenix.PubSub.PG2]

#config :logger, :console,
#       format: "$time $metadata [$level] $message\n",
#       metadata: [:file, :line]

config :logger_json, :backend,
       metadata: :all,
       formatter: Api.Formatters.CustomLogger

config :logger,
       backends: [LoggerJSON],
       handle_otp_reports: true,
       handle_sasl_reports: true

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

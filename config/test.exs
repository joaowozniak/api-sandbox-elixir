import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
#config :teller_sandbox, TellerSandbox.Repo,
#  username: "postgres",
#  password: "postgres",
#  database: "teller_sandbox_test#{System.get_env("MIX_TEST_PARTITION")}",
#  hostname: "localhost",
#  pool: Ecto.Adapters.SQL.Sandbox,
#  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :teller_sandbox, TellerSandboxWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "pLSN9ChfSYEF7HyF7VzY0QI4dDTw+K3OcGsfRsbxDFGbnXiauyv1h5UWInY0q9Ts",
  server: false

# In test we don't send emails.
config :teller_sandbox, TellerSandbox.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :liveview_client, LiveviewClientWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "ucGVE3xePlUDDfYrEIRCnLH2jjS7UjUlIZA1l3L93slbqF0Mcj6ux6DAPqmj6+W6",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

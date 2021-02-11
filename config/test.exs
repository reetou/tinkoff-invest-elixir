use Mix.Config

config :tinkoff_invest,
  mode: :sandbox,
  token: System.get_env("TINKOFF_TOKEN", "some_token"),
  broker_account_id: System.get_env("TINKOFF_BROKER_ACCOUNT_ID", "account_id")

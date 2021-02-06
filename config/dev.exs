use Mix.Config

config :tinkoff_invest,
  mode: :sandbox,
  token: System.fetch_env!("TINKOFF_TOKEN"),
  broker_account_id: System.fetch_env!("TINKOFF_BROKER_ACCOUNT_ID")

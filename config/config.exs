use Mix.Config

config :tinkoff_invest,
  endpoint: "https://api-invest.tinkoff.ru/openapi",
  mode: :production

if Mix.env() in [:dev, :test] do
  import_config "#{Mix.env()}.exs"
end

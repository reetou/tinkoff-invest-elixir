use Mix.Config

config :tinkoff_invest,
  mode: :production

if Mix.env() in [:dev, :test] do
  import_config "#{Mix.env()}.exs"
end

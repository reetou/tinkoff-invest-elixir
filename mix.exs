defmodule TinkoffInvest.MixProject do
  use Mix.Project

  def project do
    [
      app: :tinkoff_invest,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      source_url: "https://github.com/reetou/tinkoff-invest-elixir",
      homepage_url: "https://reetou.github.io/tinkoff-invest-elixir",
      docs: [
        main: "TinkoffInvest",
        extras: ["README.md"]
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"},
      {:typed_struct, "~> 0.2.1", runtime: false},
      {:ex_doc, "~> 0.23", only: :dev, runtime: false},
      {:mock, "~> 0.3.0", only: :test}
    ]
  end
end

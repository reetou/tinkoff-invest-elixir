defmodule TinkoffInvest.MixProject do
  use Mix.Project

  @description "Elixir SDK for TinkoffInvest REST API"
  @source_url "https://github.com/reetou/tinkoff-invest-elixir"

  def project do
    [
      app: :tinkoff_invest,
      version: "0.1.1",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      description: @description,
      source_url: @source_url,
      package: package(),
      docs: [
        main: "readme",
        extras: [
          "README.md",
          "CHANGELOG.md",
          "guides/introduction/Methods.md",
          "guides/introduction/Configuration.md"
        ],
        extra_section: "GUIDES",
        groups_for_extras: groups_for_extras(),
        groups_for_modules: [
          "Public API": [
            TinkoffInvest,
            TinkoffInvest.Orders,
            TinkoffInvest.Operations,
            TinkoffInvest.Portfolio,
            TinkoffInvest.Sandbox,
            TinkoffInvest.User,
            TinkoffInvest.Api
          ]
        ]
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

  defp groups_for_extras do
    [
      Introduction: ~r/guides\/introduction\/.?/
    ]
  end

  defp package do
    [
      maintainers: ["Vladimir Sinitsyn"],
      licenses: ["MIT"],
      links: %{
        Changelog: @source_url <> "/blob/master/CHANGELOG.md",
        GitHub: @source_url
      }
    ]
  end
end

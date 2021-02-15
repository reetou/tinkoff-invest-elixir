![Stonks](https://i.imgur.com/xkNPyqU.jpg)

# TinkoffInvest

TinkoffInvest SDK Elixir programming language.

REST клиент для Тинькофф.Инвестиций на Elixir.

## Installation

The package can be installed
by adding `tinkoff_invest` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tinkoff_invest, "~> 0.2"}
  ]
end
```

## Configuration

```elixir
config :tinkoff_invest, 
  token: "MYTOKEN",
  broker_account_id: "123",
  mode: :production # You can also use :sandbox for Sandbox mode (:production by default)
  # Tokens and account ids are different depending on your mode
```

## Example

Get stonks

```elixir
TinkoffInvest.Market.stocks() 
|> TinkoffInvest.payload() 
|> Enum.map(fn %TinkoffInvest.Model.Instrument{figi: figi} -> 
  IO.inspect(figi, label: "Stock FIGI: ") 
end)
```

See `TinkoffInvest` module for more details

Documentation: [https://hexdocs.pm/tinkoff_invest](https://hexdocs.pm/tinkoff_invest).


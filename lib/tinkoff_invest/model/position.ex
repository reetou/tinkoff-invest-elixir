defmodule TinkoffInvest.Model.Position do
  alias TinkoffInvest.Model.Position.AveragePositionPrice
  alias TinkoffInvest.Model.Position.ExpectedYield
  use TypedStruct

  typedstruct enforce: true do
    field(:figi, String.t())
    field(:ticker, String.t())
    field(:isin, String.t())
    field(:instrument_type, String.t())
    field(:name, String.t())
    field(:balance, float())
    field(:blocked, float())
    field(:lots, integer())
    field(:expected_yield, ExpectedYield.t())
    field(:average_position_price, AveragePositionPrice.t())
    field(:average_position_price_non_kd, AveragePositionPrice.t())
  end

  def new(%{"positions" => x}) when is_list(x), do: Enum.map(x, &new/1)

  def new(
        %{
          "ticker" => ticker,
          "figi" => figi,
          "isin" => isin,
          "instrumentType" => instrument_type,
          "name" => name,
          "balance" => balance,
          "blocked" => blocked,
          "lots" => lots
        } = params
      ) do
    %__MODULE__{
      ticker: ticker,
      figi: figi,
      isin: isin,
      instrument_type: instrument_type,
      name: name,
      balance: balance,
      blocked: blocked,
      lots: lots,
      expected_yield: optional(params, "expectedYield", ExpectedYield),
      average_position_price: optional(params, "averagePositionPrice", AveragePositionPrice),
      average_position_price_non_kd:
        optional(params, "averagePositionPriceNoNkd", AveragePositionPrice)
    }
  end

  defp optional(params, key, model) do
    case Map.get(params, key) do
      nil -> nil
      value -> model.new(value)
    end
  end
end

defmodule TinkoffInvest.Model.Instrument do
  use TypedStruct

  typedstruct enforce: true do
    field(:figi, String.t())
    field(:ticker, String.t())
    field(:isin, String.t())
    field(:min_price_increment, float())
    field(:min_quantity, integer())
    field(:lot, integer())
    field(:currency, String.t())
    field(:name, String.t())
    field(:type, String.t())
  end

  def new(%{"instruments" => x}) when is_list(x), do: Enum.map(x, &new/1)

  def new(
        %{
          "figi" => figi,
          "ticker" => ticker,
          "isin" => isin,
          "minPriceIncrement" => min_price_increment,
          "lot" => lot,
          "currency" => currency,
          "name" => name,
          "type" => type
        } = params
      ) do
    %__MODULE__{
      figi: figi,
      min_quantity: Map.get(params, "minQuantity"),
      ticker: ticker,
      isin: isin,
      min_price_increment: min_price_increment,
      lot: lot,
      currency: currency,
      name: name,
      type: type
    }
  end
end

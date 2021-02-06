defmodule TinkoffInvest.Model.Position do
  alias TinkoffInvest.Model.Position.AveragePositionPrice
  alias TinkoffInvest.Model.Position.ExpectedYield
  use TypedStruct

  typedstruct enforce: true do
    field(:figi, String.t())
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

  def new(%{
        "figi" => figi,
        "isin" => isin,
        "instrumentType" => instrument_type,
        "name" => name,
        "balance" => balance,
        "blocked" => blocked,
        "lots" => lots,
        "expectedYield" => expected_yield,
        "averagePositionPrice" => average_position_price,
        "averagePositionPriceNoNkd" => average_position_price_non_kd
      }) do
    %__MODULE__{
      figi: figi,
      isin: isin,
      instrument_type: instrument_type,
      name: name,
      balance: balance,
      blocked: blocked,
      lots: lots,
      expected_yield: ExpectedYield.new(expected_yield),
      average_position_price: AveragePositionPrice.new(average_position_price),
      average_position_price_non_kd: AveragePositionPrice.new(average_position_price_non_kd)
    }
  end
end

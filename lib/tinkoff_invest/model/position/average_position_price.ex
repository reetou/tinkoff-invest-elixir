defmodule TinkoffInvest.Model.Position.AveragePositionPrice do
  use TypedStruct

  typedstruct enforce: true do
    field(:currency, String.t())
    field(:value, float())
  end

  def new(%{
        "currency" => currency,
        "value" => value
      }) do
    %__MODULE__{
      currency: currency,
      value: value
    }
  end
end

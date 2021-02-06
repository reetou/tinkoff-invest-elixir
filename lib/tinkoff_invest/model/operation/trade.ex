defmodule TinkoffInvest.Model.Operation.Trade do
  use TypedStruct

  typedstruct enforce: true do
    field(:trade_id, String.t())
    field(:date, String.t())
    field(:price, float())
    field(:quantity, integer())
  end

  def new(x) when is_list(x), do: Enum.map(x, &new/1)

  def new(%{
        "tradeId" => id,
        "date" => date,
        "price" => price,
        "quantity" => quantity
      }) do
    %__MODULE__{
      trade_id: id,
      date: date,
      price: price,
      quantity: quantity
    }
  end
end

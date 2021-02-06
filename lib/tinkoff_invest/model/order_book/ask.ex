defmodule TinkoffInvest.Model.OrderBook.Ask do
  use TypedStruct

  typedstruct enforce: true do
    field(:price, float())
    field(:quantity, integer())
  end

  def new(x) when is_list(x), do: Enum.map(x, &new/1)

  def new(%{
        "price" => price,
        "quantity" => quantity
      }) do
    %__MODULE__{
      price: price,
      quantity: quantity
    }
  end
end

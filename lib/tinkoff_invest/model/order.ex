defmodule TinkoffInvest.Model.Order do
  use TypedStruct

  typedstruct enforce: true do
    field(:order_id, String.t())
    field(:figi, String.t())
    field(:operation, String.t())
    field(:type, String.t())
    field(:status, String.t())
    field(:price, float())
    field(:requested_lots, integer())
    field(:executed_lots, integer())
  end

  def new(x) when is_list(x), do: Enum.map(x, &new/1)

  def new(%{
        "orderId" => order_id,
        "figi" => figi,
        "operation" => operation,
        "type" => type,
        "status" => status,
        "price" => price,
        "requestedLots" => requested_lots,
        "executedLots" => executed_lots
      }) do
    %__MODULE__{
      order_id: order_id,
      figi: figi,
      operation: operation,
      type: type,
      status: status,
      price: price,
      requested_lots: requested_lots,
      executed_lots: executed_lots
    }
  end
end

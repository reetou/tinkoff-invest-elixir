defmodule TinkoffInvest.Model.MarketOrder do
  alias TinkoffInvest.Model.Commission
  use TypedStruct

  typedstruct do
    field(:order_id, String.t())
    field(:operation, String.t())
    field(:status, String.t())
    field(:reject_reason, String.t())
    field(:message, String.t())
    field(:commission, Commission.t())
    field(:executed_lots, integer())
    field(:requested_lots, integer())
  end

  def new(
        %{
          "orderId" => order_id,
          "operation" => operation,
          "status" => status,
          "requestedLots" => requested_lots,
          "executedLots" => executed_lots
        } = params
      ) do
    %__MODULE__{
      order_id: order_id,
      operation: operation,
      status: status,
      reject_reason: Map.get(params, "rejectReason"),
      message: Map.get(params, "message"),
      requested_lots: requested_lots,
      executed_lots: executed_lots,
      commission: Map.get(params, "commission")
    }
  end
end

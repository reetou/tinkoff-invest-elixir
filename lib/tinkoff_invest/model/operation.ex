defmodule TinkoffInvest.Model.Operation do
  alias TinkoffInvest.Model.Operation.Trade
  alias TinkoffInvest.Model.Commission
  use TypedStruct

  typedstruct enforce: true do
    field(:id, String.t())
    field(:status, String.t())
    field(:trades, list(Trade.t()))
    field(:commission, Commission.t())
    field(:currency, String.t())
    field(:figi, String.t())
    field(:instrument_type, String.t())
    field(:is_margin_call, boolean())
    field(:date, String.t())
    field(:operation_type, String.t())
    field(:payment, float())
    field(:price, float())
    field(:quantity, integer())
    field(:quantity_executed, integer())
  end

  def new(%{"operations" => x}) when is_list(x), do: Enum.map(x, &new/1)

  def new(
        %{
          "id" => id,
          "status" => status,
          "currency" => currency,
          "figi" => figi,
          "instrumentType" => instrument_type,
          "isMarginCall" => is_margin_call,
          "date" => date,
          "operationType" => operation_type,
          "payment" => payment,
          "price" => price,
          "quantity" => quantity
        } = params
      ) do
    %__MODULE__{
      id: id,
      status: status,
      trades: optional(params, "trades", Trade),
      commission: optional(params, "commission", Commission),
      currency: currency,
      figi: figi,
      instrument_type: instrument_type,
      is_margin_call: is_margin_call,
      date: date,
      operation_type: operation_type,
      payment: payment,
      price: price,
      quantity: quantity,
      quantity_executed: Map.get(params, "quantityExecuted")
    }
  end

  defp optional(params, key, model) do
    case Map.get(params, key) do
      nil -> nil
      value -> model.new(value)
    end
  end
end

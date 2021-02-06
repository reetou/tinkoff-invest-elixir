defmodule TinkoffInvest.Model.Broker.Account do
  use TypedStruct

  typedstruct enforce: true do
    field(:broker_account_type, String.t())
    field(:broker_account_id, String.t())
  end

  def new(%{"accounts" => x}) when is_list(x), do: Enum.map(x, &new/1)

  def new(%{
        "brokerAccountType" => type,
        "brokerAccountId" => id
      }) do
    %__MODULE__{
      broker_account_id: id,
      broker_account_type: type
    }
  end
end

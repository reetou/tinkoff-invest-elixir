defmodule TinkoffInvest.Model.Currency do
  use TypedStruct

  typedstruct enforce: true do
    field(:currency, String.t())
    field(:balance, float())
    field(:blocked, float())
  end

  def new(%{"currencies" => x}) when is_list(x), do: Enum.map(x, &new/1)

  def new(
        %{
          "currency" => currency,
          "balance" => balance
        } = params
      ) do
    %__MODULE__{
      currency: currency,
      balance: balance,
      blocked: Map.get(params, "blocked")
    }
  end
end

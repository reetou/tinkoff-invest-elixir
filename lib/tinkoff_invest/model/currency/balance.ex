defmodule TinkoffInvest.Model.Currency.Balance do
  use TypedStruct

  typedstruct enforce: true do
    field(:currency, String.t())
    field(:balance, float())
  end

  def new(%{
        "currency" => currency,
        "balance" => balance
      }) do
    %__MODULE__{
      currency: currency,
      balance: balance
    }
  end
end

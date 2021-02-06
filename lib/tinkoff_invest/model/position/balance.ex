defmodule TinkoffInvest.Model.Position.Balance do
  use TypedStruct

  typedstruct enforce: true do
    field(:figi, String.t())
    field(:balance, float())
  end

  def new(%{
        "figi" => figi,
        "balance" => balance
      }) do
    %__MODULE__{
      figi: figi,
      balance: balance
    }
  end
end

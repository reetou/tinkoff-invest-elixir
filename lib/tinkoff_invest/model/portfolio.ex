defmodule TinkoffInvest.Model.Portfolio do
  use TypedStruct

  typedstruct enforce: true do
    field(:currencies, list(term()))
    field(:positions, list(term()))
  end

  def new(%{"currencies" => currencies, "positions" => positions}) do
    %__MODULE__{
      currencies: currencies,
      positions: positions
    }
  end
end

defmodule TinkoffInvest.Model.Empty do
  use TypedStruct

  typedstruct enforce: true do
  end

  def new(_) do
    %__MODULE__{}
  end
end

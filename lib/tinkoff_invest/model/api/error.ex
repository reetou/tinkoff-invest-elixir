defmodule TinkoffInvest.Model.Api.Error do
  use TypedStruct

  typedstruct do
    field(:message, String.t())
    field(:code, String.t())
  end

  def new(nil) do
    %__MODULE__{}
  end

  def new(params) do
    %__MODULE__{
      message: Map.get(params, "message"),
      code: Map.get(params, "code")
    }
  end
end

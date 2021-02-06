defmodule TinkoffInvest.Operations do
  @moduledoc """
  Context for Operations api

  Контекст для апи по операциям
  """

  alias TinkoffInvest.Api
  alias TinkoffInvest.Model
  alias TinkoffInvest.Model.Api.Response

  @doc """
  Get operations
  Parameter `figi` is optional.
  """
  @spec history(DateTime.t(), DateTime.t(), String.t() | nil) :: Response.t()
  def history(from, to, figi \\ nil) do
    # Todo model operations list
    # Todo format datetimes to iso string
    "/operations"
    |> Api.request(:get, Model.Operation, %{from: from, to: to, figi: figi})
  end
end

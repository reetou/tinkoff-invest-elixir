defmodule TinkoffInvest.User do
  @moduledoc """
  Context for User api

  Контекст для апи пользователя
  """

  alias TinkoffInvest.Api
  alias TinkoffInvest.Model
  alias TinkoffInvest.Model.Api.Response

  @doc """
  Get accounts
  """
  @spec accounts() :: Response.t()
  def accounts do
    "/user/accounts"
    |> Api.request(:get, Model.Broker.Account)
  end
end

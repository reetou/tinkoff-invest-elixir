defmodule TinkoffInvest.Portfolio do
  @moduledoc """
  Context for Portfolio api

  Контекст для апи портфеля
  """

  alias TinkoffInvest.Api
  alias TinkoffInvest.Model
  alias TinkoffInvest.Model.Api.Response

  @doc """
  Get account positions
  """
  @spec positions() :: Response.t()
  def positions do
    "/portfolio"
    |> Api.request(:get, Model.Position)
  end

  @doc """
  Get account currencies
  """
  @spec currencies() :: Response.t()
  def currencies do
    "/portfolio/currencies"
    |> Api.request(:get, Model.Currency)
  end

  @doc """
  Get full portfolio with currencies and positions
  """
  @spec full() :: Response.t()
  def full do
    %{payload: currencies} = currencies()
    %{payload: positions} = positions()
    Model.Portfolio.new(%{"currencies" => currencies, "positions" => positions})
  end
end

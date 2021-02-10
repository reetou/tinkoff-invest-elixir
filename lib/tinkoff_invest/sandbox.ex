defmodule TinkoffInvest.Sandbox do
  @moduledoc """
  Context for Sandbox api

  Контекст для апи тестовой среды
  """

  alias TinkoffInvest.Api
  alias TinkoffInvest.Model
  alias TinkoffInvest.Model.Api.Response

  @doc """
  Creates account and currency positions for client
  """
  @spec register_account() :: Response.t()
  def register_account do
    "/sandbox/register"
    |> Api.request(:post, Model.Broker.Account)
  end

  @doc """
  Removes account
  """
  @spec remove_account() :: Response.t()
  def remove_account do
    "/sandbox/remove"
    |> Api.request(:post, Model.Empty)
  end

  @doc """
  Removes all positions from account
  """
  @spec clear_positions() :: Response.t()
  def clear_positions do
    "/sandbox/clear"
    |> Api.request(:post, Model.Empty)
  end

  @doc """
  Sets currency balance by iso code
  Example:
  ```
    #{__MODULE__}.set_currency_balance("USD", 10.0)
  ```
  """
  @spec set_currency_balance(String.t(), float()) :: Response.t()
  def set_currency_balance(currency, balance) do
    "/sandbox/currencies/balance"
    |> Api.request(:post, Model.Empty, nil, %{currency: currency, balance: balance})
  end

  @doc """
  Sets position balance by figi
  Example:
  ```
    #{__MODULE__}.set_position_balance("AAPL", 10.0)
  ```
  """
  @spec set_position_balance(String.t(), float()) :: Response.t()
  def set_position_balance(figi, balance) do
    "/sandbox/currencies/balance"
    |> Api.request(:post, Model.Empty, nil, %{figi: figi, balance: balance})
  end
end

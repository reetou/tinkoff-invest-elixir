defmodule TinkoffInvest.Orders do
  @moduledoc """
  Context for Orders api. Allows you:
  - Fetch active orders
  - Create limit order
  - Create market order
  - Cancel order

  Контекст для апи заявок, позволяет:
  - Получить активные заявки
  - Создать лимитную заявку
  - Создать рыночную заявку
  - Отменить заявку
  """

  alias TinkoffInvest.Api
  alias TinkoffInvest.Model
  alias TinkoffInvest.Model.Api.Response

  @doc """
  Returns active orders
  """
  @spec active_orders() :: Response.t()
  def active_orders do
    "/orders"
    |> Api.request(:get, Model.Order)
  end

  @doc """
  Creates limit order by figi
  """
  @spec create_limit_order(String.t()) :: Response.t()
  def create_limit_order(figi) do
    "/orders/limit-order"
    |> Api.request(:post, Model.LimitOrder, %{figi: figi})
  end

  @doc """
  Creates market order by figi
  """
  @spec create_market_order(String.t()) :: Response.t()
  def create_market_order(figi) do
    "/orders/market-order"
    |> Api.request(:post, Model.MarketOrder, %{figi: figi})
  end

  @doc """
  Cancels order by order_id
  """
  @spec cancel_order(String.t()) :: Response.t()
  def cancel_order(order_id) do
    "/orders/cancel"
    |> Api.request(:post, Model.Empty, %{orderId: order_id})
  end
end

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

  @type order_operation() :: :buy | :sell
  @order_operations [:buy, :sell]

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
  @spec create_limit_order(String.t(), integer(), order_operation(), float()) :: Response.t()
  def create_limit_order(figi, lots, op, price) when op in @order_operations do
    "/orders/limit-order"
    |> Api.request(:post, Model.LimitOrder, %{figi: figi}, %{
      lots: lots,
      operation: operation(op),
      price: price
    })
  end

  @doc """
  Creates market order by figi
  """
  @spec create_market_order(String.t(), integer(), order_operation()) :: Response.t()
  def create_market_order(figi, lots, op) when op in @order_operations do
    "/orders/market-order"
    |> Api.request(:post, Model.MarketOrder, %{figi: figi}, %{
      lots: lots,
      operation: operation(op)
    })
  end

  @doc """
  Cancels order by order_id
  """
  @spec cancel_order(String.t()) :: Response.t()
  def cancel_order(order_id) do
    "/orders/cancel"
    |> Api.request(:post, Model.Empty, %{orderId: order_id})
  end

  defp operation(:buy), do: "Buy"
  defp operation(:sell), do: "Sell"
end

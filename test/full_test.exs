defmodule TinkoffInvestTest.FullTest do
  use ExUnit.Case, async: false
  doctest TinkoffInvest
  alias TinkoffInvest
  alias TinkoffInvest.Model.Api.Response
  alias TinkoffInvest.Orders
  alias TinkoffInvest.Market
  alias TinkoffInvest.Operations
  alias TinkoffInvest.Sandbox
  alias TinkoffInvest.Portfolio
  alias TinkoffInvest.User
  alias TinkoffInvest.HistoricalData

  @moduledoc """
  Module for testing real API without mocking HTTP requests

  Used only manually with sandbox token.
  """

  @moduletag :skip
  # Uncomment this to make full test
  # @moduletag :full_test

  setup do
    %{payload: %{broker_account_id: acc_id}} = Sandbox.register_account()
    :ok = TinkoffInvest.change_account_id(acc_id)
    now = DateTime.now!("Etc/UTC")
    from = now |> DateTime.add(-3600, :second)
    interval = "1min"

    [
      figi: "BBG000B9XRY4",
      ticker: "AAPL",
      from: from,
      to: now,
      interval: interval
    ]
  end

  defp assert_not_internal_error(%Response{payload: %{code: _, message: _} = payload} = r) do
    payload = Map.put(payload, :message, "INTERNAL_ERROR")
    x = Map.put(r, :payload, payload)
    assert x != r
    r
  end

  defp assert_not_internal_error(x), do: x

  describe "Historical data" do
    setup do
      offset_secs = 86400 * 5 * -1
      now = DateTime.utc_now()
      from = now |> DateTime.add(offset_secs, :second)
      to = now
      figi = "BBG000B9XRY4"
      %{now: now, from: from, to: to, figi: figi}
    end

    test "Get candles with interval minute from last week to now", %{
      from: from,
      to: to,
      figi: figi
    } do
      interval = "1min"
      result = HistoricalData.candles(figi, from, to, interval)
      assert is_list(result)
      assert length(result) > 0
    end

    test "Get candles with interval hour from last week to now", %{from: from, to: to, figi: figi} do
      interval = "hour"
      result = HistoricalData.candles(figi, from, to, interval)
      assert is_list(result)
      assert length(result) > 0
    end

    test "Get candles with interval day from last week to now", %{from: from, to: to, figi: figi} do
      interval = "day"
      result = HistoricalData.candles(figi, from, to, interval)
      assert is_list(result)
      assert length(result) > 0
    end

    test "Get candles with interval week from last week to now", %{from: from, to: to, figi: figi} do
      secs = 86400 * 7 * 3 * -1
      from = from |> DateTime.add(secs, :second)
      interval = "week"
      result = HistoricalData.candles(figi, from, to, interval)
      assert is_list(result)
      assert length(result) > 0
    end

    test "Get candles with interval month from last week to now", %{
      from: from,
      to: to,
      figi: figi
    } do
      secs = 86400 * 30 * 3 * -1
      from = from |> DateTime.add(secs, :second)
      interval = "month"
      result = HistoricalData.candles(figi, from, to, interval)
      assert is_list(result)
      assert length(result) > 0
    end
  end

  describe "Orders" do
    test "create_market_order", %{figi: figi} do
      Orders.create_market_order(figi, 2, :buy)
      |> assert_not_internal_error()
    end

    test "create_limit_order", %{figi: figi} do
      Orders.create_limit_order(figi, 2, :sell, 150.50)
      |> assert_not_internal_error()
    end

    test "cancel_order" do
      Orders.cancel_order("123")
      |> assert_not_internal_error()
    end

    test "active_orders" do
      Orders.active_orders()
      |> assert_not_internal_error()
    end
  end

  describe "Market" do
    test "stocks" do
      Market.stocks()
      |> assert_not_internal_error()
    end

    test "bonds" do
      Market.bonds()
      |> assert_not_internal_error()
    end

    test "etfs" do
      Market.etfs()
      |> assert_not_internal_error()
    end

    test "currencies" do
      Market.etfs()
      |> assert_not_internal_error()
    end

    test "orderbook", %{figi: figi} do
      Market.orderbook(figi)
      |> assert_not_internal_error()
    end

    test "candles", %{figi: figi, from: from, to: to, interval: interval} do
      Market.candles(figi, from, to, interval)
      |> assert_not_internal_error()
    end

    test "search_figi", %{figi: figi} do
      Market.search_figi(figi)
      |> assert_not_internal_error()
    end

    test "search_ticker", %{ticker: ticker} do
      Market.search_ticker(ticker)
      |> assert_not_internal_error()
    end
  end

  describe "Operations" do
    test "history", %{from: from, to: to, figi: figi} do
      Operations.history(from, to, figi)
      |> assert_not_internal_error()

      Operations.history(from, to)
      |> assert_not_internal_error()
    end
  end

  describe "Portfolio" do
    test "positions" do
      Portfolio.positions()
      |> assert_not_internal_error()
    end

    test "currencies" do
      Portfolio.currencies()
      |> assert_not_internal_error()
    end

    test "full" do
      Portfolio.full()
      |> assert_not_internal_error()
    end
  end

  describe "User" do
    test "accounts" do
      User.accounts()
      |> assert_not_internal_error()
    end
  end

  describe "Sandbox" do
    test "set_currency_balance" do
      Sandbox.set_currency_balance("USD", 123)
      |> assert_not_internal_error()
    end

    test "set_position_balance", %{figi: figi} do
      Sandbox.set_position_balance(figi, 123)
      |> assert_not_internal_error()
    end

    test "clear_positions" do
      Sandbox.clear_positions()
      |> assert_not_internal_error()
    end

    test "remove_account" do
      Sandbox.remove_account()
      |> assert_not_internal_error()
    end
  end
end

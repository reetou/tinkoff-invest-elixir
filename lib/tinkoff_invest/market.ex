defmodule TinkoffInvest.Market do
  @moduledoc """
  Context for Market api

  Контекст для апи по бумагам
  """

  alias TinkoffInvest.Api
  alias TinkoffInvest.Model
  alias TinkoffInvest.Model.Api.Response

  @doc """
  Get market stocks list
  """
  @spec stocks() :: Response.t()
  def stocks, do: "/market/stocks" |> Api.request(:get, Model.Instrument)

  @doc """
  Get market bonds list
  """
  @spec bonds() :: Response.t()
  def bonds, do: "/market/bonds" |> Api.request(:get, Model.Instrument)

  @doc """
  Get market ETF list
  """
  @spec etfs() :: Response.t()
  def etfs, do: "/market/etfs" |> Api.request(:get, Model.Instrument)

  @doc """
  Get market currencies list
  """
  @spec currencies() :: Response.t()
  def currencies, do: "/market/currencies" |> Api.request(:get, Model.Instrument)

  @doc """
  Get market orderbook by FIGI and depth
  """
  @spec orderbook(String.t(), integer()) :: Response.t()
  def orderbook(figi, depth \\ 20),
    do: "/market/orderbook" |> Api.request(:get, Model.OrderBook, %{figi: figi, depth: depth})

  @doc """
  Get market candles history by FIGI 
  """
  @spec candles(String.t(), DateTime.t(), DateTime.t(), String.t()) :: Response.t()
  def candles(figi, from, to, interval \\ "1min") do
    # TODO: Format datetime to iso string
    "/market/candles"
    |> Api.request(:get, Model.Candle, %{figi: figi, from: from, to: to, interval: interval})
  end

  @doc """
  Get market instrument by FIGI
  """
  @spec search_figi(String.t()) :: Response.t()
  def search_figi(figi) do
    "/market/search/by-figi"
    |> Api.request(:get, Model.Instrument, %{figi: figi})
  end

  @doc """
  Get market instrument list by ticker
  """
  @spec search_ticker(String.t()) :: Response.t()
  def search_ticker(ticker) do
    # Todo model instruments list
    "/market/search/by-ticker"
    |> Api.request(:get, Model.Instrument, %{ticker: ticker})
  end
end

defmodule TinkoffInvest.HistoricalData do
  @moduledoc """
  Module for getting historical data for a security.

  Useful when testing your algo or just need some insight on past prices
  """
  alias TinkoffInvest.Market
  alias TinkoffInvest.Model.Candle
  require Logger

  @intervals [
    "1min",
    "2min",
    "3min",
    "5min",
    "10min",
    "15min",
    "30min",
    "hour",
    "day",
    "week",
    "month"
  ]

  @doc """
  Get candle history for specified figi by from, to and interval

  Example:

  ```
  from = DateTime.utc_now() |> DateTime.add(-86400, :second)
  to = DateTime.utc_now()
  TinkoffInvest.HistoricalData.candles("SOMEFIGI", from, to, "1min")
  ```

  Possible intervals:

  #{@intervals |> Enum.map(fn x -> x end) |> Enum.join(", ")}
  """
  @spec candles(String.t(), DateTime.t(), DateTime.t(), String.t()) :: list(Candle.t())
  def candles(figi, from, to, interval) when interval in @intervals do
    interval
    |> shift_opts()
    |> shift(from)
    |> diff(to)
    |> to_range(interval)
    |> Enum.map(fn inc ->
      from_shifted = shift([days: inc], from)
      to_shifted = shift([days: inc + step(interval)], from)
      do_candles(figi, from_shifted, to_shifted, interval)
    end)
    |> List.flatten()
  end

  def shift_opts(interval) do
    case interval do
      "hour" -> [weeks: 1]
      "day" -> [days: 365]
      "week" -> [days: 728]
      "month" -> [days: 365 * 10]
      _ -> [days: 1]
    end
  end

  def shift(opts, date) do
    Timex.shift(date, opts)
  end

  defp diff(from, to) do
    Timex.diff(from, to, :days)
  end

  defp to_range(count, interval) do
    s = step(interval)
    to = abs(count)

    0
    |> Range.new(to)
    |> Enum.take_every(s)
  end

  defp step(interval) do
    interval
    |> case do
      "hour" -> Timex.Duration.from_weeks(1)
      "day" -> Timex.Duration.from_days(365)
      "week" -> Timex.Duration.from_days(728)
      "month" -> Timex.Duration.from_days(365 * 10)
      _ -> Timex.Duration.from_days(1)
    end
    |> Timex.Duration.to_days(truncate: true)
  end

  defp do_candles(figi, from, to, interval) do
    figi
    |> Market.candles(from, to, interval)
    |> TinkoffInvest.payload()
    |> case do
      x when is_list(x) -> x
      e -> raise "Api error: #{inspect(e)}"
    end
  end
end

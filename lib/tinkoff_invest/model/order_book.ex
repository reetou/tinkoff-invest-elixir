defmodule TinkoffInvest.Model.OrderBook do
  use TypedStruct
  alias TinkoffInvest.Model.OrderBook.Bid
  alias TinkoffInvest.Model.OrderBook.Ask

  typedstruct enforce: true do
    field(:figi, String.t())
    field(:trade_status, String.t())
    field(:depth, integer())
    field(:min_price_increment, float())
    field(:face_value, float())
    field(:last_price, float())
    field(:close_price, float())
    field(:limit_up, float())
    field(:limit_down, float())
    field(:bids, list(Bid.t()))
    field(:asks, list(Ask.t()))
  end

  def new(
        %{
          "figi" => figi,
          "tradeStatus" => trade_status,
          "depth" => depth,
          "minPriceIncrement" => min_price_increment,
          "lastPrice" => last_price,
          "closePrice" => close_price,
          "bids" => bids,
          "asks" => asks
        } = params
      ) do
    %__MODULE__{
      figi: figi,
      trade_status: trade_status,
      depth: depth,
      min_price_increment: min_price_increment,
      face_value: Map.get(params, "faceValue"),
      last_price: last_price,
      close_price: close_price,
      limit_up: Map.get(params, "limitUp"),
      limit_down: Map.get(params, "limitDown"),
      bids: Bid.new(bids),
      asks: Ask.new(asks)
    }
  end
end

defmodule TinkoffInvestTest.MarketTest do
  use ExUnit.Case
  doctest TinkoffInvest
  alias TinkoffInvest.Model.Api.Response
  alias TinkoffInvest.Model
  alias TinkoffInvest.Market
  import Mock
  import TinkoffInvest.TestMocks

  describe "Market" do
    @response Response.new(%{
                "trackingId" => "1234",
                "status" => "Ok",
                "payload" => %{
                  "total" => 0,
                  "instruments" => [
                    %{
                      "figi" => "string",
                      "ticker" => "string",
                      "isin" => "string",
                      "minPriceIncrement" => 0,
                      "lot" => 0,
                      "minQuantity" => 0,
                      "currency" => "RUB",
                      "name" => "string",
                      "type" => "Stock"
                    }
                  ]
                },
                "status_code" => 200
              })
    @expected %Response{
      payload: [
        %Model.Instrument{
          figi: "string",
          isin: "string",
          name: "string",
          currency: "RUB",
          lot: 0,
          min_price_increment: 0,
          min_quantity: 0,
          ticker: "string",
          type: "Stock"
        }
      ],
      tracking_id: "1234",
      status: "Ok",
      status_code: 200
    }
    http_mock "Get stonks" do
      assert @expected == Market.stocks()
    end

    @response Response.new(%{
                "trackingId" => "1234",
                "status" => "Ok",
                "payload" => %{
                  "total" => 0,
                  "instruments" => [
                    %{
                      "figi" => "string",
                      "ticker" => "string",
                      "isin" => "string",
                      "minPriceIncrement" => 0,
                      "lot" => 0,
                      "minQuantity" => 0,
                      "currency" => "RUB",
                      "name" => "string",
                      "type" => "Bond"
                    }
                  ]
                },
                "status_code" => 200
              })
    @expected %Response{
      payload: [
        %Model.Instrument{
          figi: "string",
          isin: "string",
          name: "string",
          currency: "RUB",
          lot: 0,
          min_price_increment: 0,
          min_quantity: 0,
          ticker: "string",
          type: "Bond"
        }
      ],
      tracking_id: "1234",
      status: "Ok",
      status_code: 200
    }
    http_mock "Get bonds" do
      assert @expected == Market.bonds()
    end

    @response Response.new(%{
                "trackingId" => "1234",
                "status" => "Ok",
                "payload" => %{
                  "total" => 0,
                  "instruments" => [
                    %{
                      "figi" => "string",
                      "ticker" => "string",
                      "isin" => "string",
                      "minPriceIncrement" => 0,
                      "lot" => 0,
                      "minQuantity" => 0,
                      "currency" => "USD",
                      "name" => "string",
                      "type" => "ETF"
                    }
                  ]
                },
                "status_code" => 200
              })
    @expected %Response{
      payload: [
        %Model.Instrument{
          figi: "string",
          isin: "string",
          name: "string",
          currency: "USD",
          lot: 0,
          min_price_increment: 0,
          min_quantity: 0,
          ticker: "string",
          type: "ETF"
        }
      ],
      tracking_id: "1234",
      status: "Ok",
      status_code: 200
    }
    http_mock "Get ETFs" do
      assert @expected == Market.etfs()
    end

    @response Response.new(%{
                "trackingId" => "12334",
                "status" => "Ok",
                "payload" => %{
                  "total" => 0,
                  "instruments" => [
                    %{
                      "figi" => "string",
                      "ticker" => "string",
                      "isin" => "string",
                      "minPriceIncrement" => 0,
                      "lot" => 0,
                      "minQuantity" => 0,
                      "currency" => "UTH",
                      "name" => "string",
                      "type" => "Currency"
                    }
                  ]
                },
                "status_code" => 200
              })
    @expected %Response{
      payload: [
        %Model.Instrument{
          figi: "string",
          isin: "string",
          name: "string",
          currency: "UTH",
          lot: 0,
          min_price_increment: 0,
          min_quantity: 0,
          ticker: "string",
          type: "Currency"
        }
      ],
      tracking_id: "12334",
      status: "Ok",
      status_code: 200
    }
    http_mock "Get Currencies" do
      assert @expected == Market.currencies()
    end

    @response Response.new(%{
                "trackingId" => "12334",
                "status" => "Ok",
                "payload" => %{
                  "figi" => "string",
                  "depth" => 0,
                  "bids" => [
                    %{
                      "price" => 0,
                      "quantity" => 0
                    }
                  ],
                  "asks" => [
                    %{
                      "price" => 0,
                      "quantity" => 0
                    }
                  ],
                  "tradeStatus" => "NormalTrading",
                  "minPriceIncrement" => 0,
                  "faceValue" => 0,
                  "lastPrice" => 0,
                  "closePrice" => 0,
                  "limitUp" => 0,
                  "limitDown" => 0
                },
                "status_code" => 200
              })
    @expected %Response{
      payload: %Model.OrderBook{
        asks: [%Model.OrderBook.Ask{price: 0, quantity: 0}],
        bids: [%Model.OrderBook.Bid{price: 0, quantity: 0}],
        close_price: 0,
        depth: 0,
        face_value: 0,
        figi: "string",
        last_price: 0,
        limit_down: 0,
        limit_up: 0,
        min_price_increment: 0,
        trade_status: "NormalTrading"
      },
      tracking_id: "12334",
      status: "Ok",
      status_code: 200
    }
    http_mock "Get orderbook" do
      assert @expected == Market.orderbook("AAPL", 20)
    end

    @response Response.new(%{
                "trackingId" => "12334",
                "status" => "Ok",
                "payload" => %{
                  "figi" => "string",
                  "interval" => "1min",
                  "candles" => [
                    %{
                      "figi" => "string",
                      "interval" => "1min",
                      "o" => 0,
                      "c" => 0,
                      "h" => 0,
                      "l" => 0,
                      "v" => 0,
                      "time" => "2019-08-19T18:38:33.131642+03:00"
                    }
                  ]
                },
                "status_code" => 200
              })
    @expected %Response{
      payload: [
        %TinkoffInvest.Model.Candle{
          time: "2019-08-19T18:38:33.131642+03:00",
          figi: "string",
          interval: "1min",
          c: 0,
          h: 0,
          l: 0,
          o: 0,
          v: 0
        }
      ],
      tracking_id: "12334",
      status: "Ok",
      status_code: 200
    }
    http_mock "Get candles" do
      now = DateTime.utc_now()
      from = now |> DateTime.add(-3600)
      to = now
      assert @expected == Market.candles("AAPL", from, to, "1min")
    end

    @response Response.new(%{
                "trackingId" => "12334",
                "status" => "Ok",
                "payload" => %{
                  "code" => "MALFORMED_QUERY_PARAMETER",
                  "message" => "Неверный формат поля 'from' в запросе"
                },
                "status_code" => 500
              })
    @expected %Response{
      payload: %TinkoffInvest.Model.Api.Error{
        code: "MALFORMED_QUERY_PARAMETER",
        message: "Неверный формат поля 'from' в запросе"
      },
      tracking_id: "12334",
      status: "Ok",
      status_code: 500
    }
    http_mock "Get candles error" do
      now = DateTime.utc_now()
      from = now |> DateTime.add(-3600)
      to = now
      assert @expected == Market.candles("AAPL", from, to, "1min")
    end

    @response Response.new(%{
                "trackingId" => "12334",
                "status" => "Ok",
                "payload" => %{
                  "figi" => "string",
                  "ticker" => "string",
                  "isin" => "string",
                  "minPriceIncrement" => 0,
                  "lot" => 0,
                  "currency" => "RUB",
                  "name" => "string",
                  "type" => "Stock"
                },
                "status_code" => 200
              })
    @expected %Response{
      payload: %Model.Instrument{
        currency: "RUB",
        figi: "string",
        isin: "string",
        lot: 0,
        min_price_increment: 0,
        min_quantity: nil,
        name: "string",
        ticker: "string",
        type: "Stock"
      },
      tracking_id: "12334",
      status: "Ok",
      status_code: 200
    }
    http_mock "Search instrument by FIGI" do
      assert @expected == Market.search_figi("AAPL")
    end

    @response Response.new(%{
                "trackingId" => "12334",
                "status" => "Ok",
                "payload" => %{
                  "total" => 0,
                  "instruments" => [
                    %{
                      "figi" => "string",
                      "ticker" => "string",
                      "isin" => "string",
                      "minPriceIncrement" => 0,
                      "lot" => 0,
                      "minQuantity" => 10,
                      "currency" => "RUB",
                      "name" => "string",
                      "type" => "Stock"
                    }
                  ]
                },
                "status_code" => 200
              })
    @expected %Response{
      payload: [
        %TinkoffInvest.Model.Instrument{
          currency: "RUB",
          figi: "string",
          isin: "string",
          lot: 0,
          min_price_increment: 0,
          min_quantity: 10,
          name: "string",
          ticker: "string",
          type: "Stock"
        }
      ],
      tracking_id: "12334",
      status: "Ok",
      status_code: 200
    }
    http_mock "Search instrument by Ticker" do
      assert @expected == Market.search_ticker("ticker123")
    end
  end
end

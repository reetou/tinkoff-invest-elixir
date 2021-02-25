defmodule TinkoffInvestTest.OperationsTest do
  use ExUnit.Case
  alias TinkoffInvest.Model.Api.Response
  alias TinkoffInvest.Model
  alias TinkoffInvest.Operations
  import Mock
  import TinkoffInvestTest.TestMocks

  describe "Operations" do
    @response Response.new(%{
                "trackingId" => "1234",
                "status" => "Ok",
                "payload" => %{
                  "operations" => [
                    %{
                      "id" => "string",
                      "status" => "Done",
                      "trades" => [
                        %{
                          "tradeId" => "string",
                          "date" => "2019-08-19T18:38:33.131642+03:00",
                          "price" => 0,
                          "quantity" => 0
                        }
                      ],
                      "commission" => %{
                        "currency" => "RUB",
                        "value" => 0
                      },
                      "currency" => "RUB",
                      "payment" => 0,
                      "price" => 0,
                      "quantity" => 0,
                      "quantityExecuted" => 0,
                      "figi" => "AAPL",
                      "instrumentType" => "Stock",
                      "isMarginCall" => true,
                      "date" => "2019-08-19T18:38:33.131642+03:00",
                      "operationType" => "Buy"
                    }
                  ]
                },
                "status_code" => 200
              })
    @expected %Response{
      payload: [
        %Model.Operation{
          currency: "RUB",
          figi: "AAPL",
          commission: %Model.Commission{
            currency: "RUB",
            value: 0
          },
          date: "2019-08-19T18:38:33.131642+03:00",
          id: "string",
          instrument_type: "Stock",
          is_margin_call: true,
          operation_type: "Buy",
          payment: 0,
          price: 0,
          quantity: 0,
          quantity_executed: 0,
          status: "Done",
          trades: [
            %Model.Operation.Trade{
              date: "2019-08-19T18:38:33.131642+03:00",
              price: 0,
              quantity: 0,
              trade_id: "string"
            }
          ]
        }
      ],
      tracking_id: "1234",
      status: "Ok",
      status_code: 200
    }
    http_mock "Get history" do
      now = DateTime.utc_now()
      from = now |> DateTime.add(-3600)
      to = now
      assert @expected == Operations.history(from, to, "AAPL")
    end

    @response Response.new(%{
                "trackingId" => "1234",
                "status" => "Ok",
                "payload" => %{
                  "operations" => [
                    %{
                      "id" => "string",
                      "status" => "Done",
                      "trades" => [
                        %{
                          "tradeId" => "string",
                          "date" => "2019-08-19T18:38:33.131642+03:00",
                          "price" => 0,
                          "quantity" => 0
                        }
                      ],
                      "commission" => %{
                        "currency" => "RUB",
                        "value" => 0
                      },
                      "currency" => "RUB",
                      "payment" => 0,
                      "price" => 0,
                      "quantity" => 0,
                      "quantityExecuted" => 0,
                      "figi" => "string",
                      "instrumentType" => "Stock",
                      "isMarginCall" => true,
                      "date" => "2019-08-19T18:38:33.131642+03:00",
                      "operationType" => "Buy"
                    }
                  ]
                },
                "status_code" => 200
              })
    @expected %Response{
      payload: [
        %Model.Operation{
          currency: "RUB",
          figi: "string",
          commission: %Model.Commission{
            currency: "RUB",
            value: 0
          },
          date: "2019-08-19T18:38:33.131642+03:00",
          id: "string",
          instrument_type: "Stock",
          is_margin_call: true,
          operation_type: "Buy",
          payment: 0,
          price: 0,
          quantity: 0,
          quantity_executed: 0,
          status: "Done",
          trades: [
            %Model.Operation.Trade{
              date: "2019-08-19T18:38:33.131642+03:00",
              price: 0,
              quantity: 0,
              trade_id: "string"
            }
          ]
        }
      ],
      tracking_id: "1234",
      status: "Ok",
      status_code: 200
    }
    http_mock "Get history without figi" do
      now = DateTime.utc_now()
      from = now |> DateTime.add(-3600)
      to = now
      assert @expected == Operations.history(from, to)
    end
  end
end

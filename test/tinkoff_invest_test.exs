defmodule TinkoffInvestTest do
  use ExUnit.Case
  doctest TinkoffInvest
  alias TinkoffInvest.Model.Api.Response
  alias TinkoffInvest.Model
  import Mock
  import TinkoffInvest.TestMocks

  describe "Configuration" do
    test "Should change token successfully" do
      token = Application.fetch_env!(:tinkoff_invest, :token)
      new_token = token <> "123d"
      assert :ok = TinkoffInvest.change_token(new_token)
      assert new_token == Application.fetch_env!(:tinkoff_invest, :token)
    end

    test "Should change broker account id successfully" do
      account_id = Application.fetch_env!(:tinkoff_invest, :token)
      new_account_id = account_id <> "1243d"
      assert :ok = TinkoffInvest.change_account_id(new_account_id)
      assert new_account_id == Application.fetch_env!(:tinkoff_invest, :broker_account_id)
    end

    test "Should change mode and endpoint url successfully" do
      assert :production = TinkoffInvest.mode()
      assert TinkoffInvest.endpoint() == TinkoffInvest.default_endpoint()
      assert :ok = TinkoffInvest.set_mode(:sandbox)
      assert :sandbox = TinkoffInvest.mode()
      assert TinkoffInvest.endpoint() != TinkoffInvest.default_endpoint()
      assert TinkoffInvest.endpoint() =~ TinkoffInvest.default_endpoint()
    end

    test "Should get payload from response struct" do
      payload = 123

      result =
        %{"status_code" => 250, "payload" => payload}
        |> Response.new()
        |> TinkoffInvest.payload()

      assert result == payload
    end
  end

  describe "User accounts" do
    @response Response.new(%{
                "status_code" => 500,
                "payload" => %{
                  "code" => nil,
                  "message" => "123"
                }
              })
    @expected %Response{
      payload: %TinkoffInvest.Model.Api.Error{
        code: nil,
        message: "123"
      },
      status_code: 500,
      tracking_id: nil,
      status: nil
    }
    http_mock "Error" do
      assert @expected == TinkoffInvest.accounts()
    end

    @response Response.new(%{
                "trackingId" => "123",
                "status" => "Ok",
                "payload" => %{"accounts" => []},
                "status_code" => 200
              })
    @expected %Response{payload: [], tracking_id: "123", status: "Ok", status_code: 200}
    http_mock "Empty accounts list" do
      assert @expected == TinkoffInvest.accounts()
    end

    @response Response.new(%{
                "trackingId" => "1234",
                "status" => "Ok",
                "payload" => %{
                  "accounts" => [
                    %{"brokerAccountType" => "Tinkoff", "brokerAccountId" => "123"}
                  ]
                },
                "status_code" => 200
              })
    @expected %Response{
      payload: [%Model.Broker.Account{broker_account_id: "123", broker_account_type: "Tinkoff"}],
      tracking_id: "1234",
      status: "Ok",
      status_code: 200
    }
    http_mock "Get accounts" do
      assert @expected == TinkoffInvest.accounts()
    end
  end

  describe "Orders" do
    @response Response.new(%{
                "trackingId" => "1234",
                "status" => "Ok",
                "payload" => [
                  %{
                    "orderId" => "string",
                    "figi" => "string",
                    "operation" => "Buy",
                    "status" => "New",
                    "requestedLots" => 0,
                    "executedLots" => 0,
                    "type" => "Limit",
                    "price" => 0
                  }
                ],
                "status_code" => 200
              })
    @expected %Response{
      payload: [
        %TinkoffInvest.Model.Order{
          executed_lots: 0,
          figi: "string",
          operation: "Buy",
          order_id: "string",
          price: 0,
          requested_lots: 0,
          status: "New",
          type: "Limit"
        }
      ],
      tracking_id: "1234",
      status: "Ok",
      status_code: 200
    }
    http_mock "Get orders" do
      assert @expected == TinkoffInvest.active_orders()
    end

    @response Response.new(%{
                "trackingId" => "1234",
                "status" => "Ok",
                "payload" => %{},
                "status_code" => 200
              })
    @expected %Response{
      payload: %Model.Empty{},
      tracking_id: "1234",
      status: "Ok",
      status_code: 200
    }
    http_mock "Cancel order" do
      assert @expected == TinkoffInvest.cancel_order("123")
    end

    @response Response.new(%{
                "trackingId" => "1234",
                "status" => "Ok",
                "payload" => %{
                  "orderId" => "string",
                  "operation" => "Buy",
                  "status" => "New",
                  "rejectReason" => "string",
                  "message" => "string",
                  "requestedLots" => 0,
                  "executedLots" => 2,
                  "commission" => %{
                    "currency" => "RUB",
                    "value" => 1
                  }
                },
                "status_code" => 200
              })
    @expected %Response{
      payload: %Model.LimitOrder{
        commission: %{"currency" => "RUB", "value" => 1},
        executed_lots: 2,
        message: "string",
        operation: "Buy",
        order_id: "string",
        reject_reason: "string",
        requested_lots: 0,
        status: "New"
      },
      tracking_id: "1234",
      status: "Ok",
      status_code: 200
    }
    http_mock "Create limit order" do
      assert @expected == TinkoffInvest.create_limit_order("AAPL", 2, :buy, 2.00)
    end

    @response Response.new(%{
                "payload" => %{
                  "executedLots" => 5,
                  "operation" => "Buy",
                  "orderId" => "123",
                  "requestedLots" => 5,
                  "status" => "Fill"
                },
                "status" => "Ok",
                "trackingId" => "1234",
                "status_code" => 200
              })
    @expected %Response{
      payload: %Model.MarketOrder{
        commission: nil,
        executed_lots: 5,
        message: nil,
        operation: "Buy",
        order_id: "123",
        reject_reason: nil,
        requested_lots: 5,
        status: "Fill"
      },
      tracking_id: "1234",
      status: "Ok",
      status_code: 200
    }
    http_mock "Create market order" do
      assert @expected == TinkoffInvest.create_market_order("AAPL", 2, :sell)
    end
  end

  describe "Portfolio" do
    @response Response.new(%{
                "trackingId" => "1234",
                "status" => "Ok",
                "payload" => %{
                  "currencies" => [
                    %{
                      "currency" => "RUB",
                      "balance" => 52.0,
                      "blocked" => 54.0
                    }
                  ]
                },
                "status_code" => 200
              })
    @expected %Response{
      payload: [
        %Model.Currency{
          currency: "RUB",
          balance: 52.0,
          blocked: 54.0
        }
      ],
      tracking_id: "1234",
      status: "Ok",
      status_code: 200
    }
    http_mock "Get currencies" do
      assert @expected == TinkoffInvest.Portfolio.currencies()
    end

    @response Response.new(%{
                "trackingId" => "1234",
                "status" => "Ok",
                "payload" => %{
                  "positions" => [
                    %{
                      "figi" => "string",
                      "ticker" => "RUBUSTOM123",
                      "isin" => "string",
                      "instrumentType" => "Stock",
                      "balance" => 0,
                      "blocked" => 0,
                      "expectedYield" => %{
                        "currency" => "RUB",
                        "value" => 0
                      },
                      "lots" => 0,
                      "averagePositionPrice" => %{
                        "currency" => "RUB",
                        "value" => 0
                      },
                      "averagePositionPriceNoNkd" => %{
                        "currency" => "RUB",
                        "value" => 0
                      },
                      "name" => "string"
                    }
                  ]
                },
                "status_code" => 200
              })
    @expected %Response{
      payload: [
        %Model.Position{
          average_position_price: %Model.Position.AveragePositionPrice{
            currency: "RUB",
            value: 0
          },
          average_position_price_non_kd: %Model.Position.AveragePositionPrice{
            currency: "RUB",
            value: 0
          },
          balance: 0,
          blocked: 0,
          expected_yield: %Model.Position.ExpectedYield{
            currency: "RUB",
            value: 0
          },
          figi: "string",
          ticker: "RUBUSTOM123",
          instrument_type: "Stock",
          isin: "string",
          lots: 0,
          name: "string"
        }
      ],
      tracking_id: "1234",
      status: "Ok",
      status_code: 200
    }
    http_mock "Get positions" do
      assert @expected == TinkoffInvest.Portfolio.positions()
    end
  end
end

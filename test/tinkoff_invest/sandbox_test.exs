defmodule TinkoffInvestTest.SandboxTest do
  use ExUnit.Case
  doctest TinkoffInvest
  alias TinkoffInvest.Model.Api.Response
  alias TinkoffInvest.Model
  alias TinkoffInvest.Sandbox
  import Mock
  import TinkoffInvest.TestMocks

  describe "Sandbox" do
    @response Response.new(%{
                "trackingId" => "1234",
                "status" => "Ok",
                "payload" => %{
                  "brokerAccountType" => "Tinkoff",
                  "brokerAccountId" => "4545"
                },
                "status_code" => 200
              })
    @expected %Response{
      payload: %Model.Broker.Account{
        broker_account_id: "4545",
        broker_account_type: "Tinkoff"
      },
      tracking_id: "1234",
      status: "Ok",
      status_code: 200
    }
    http_mock "Register account" do
      assert @expected == Sandbox.register_account()
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
    http_mock "Clear positions" do
      assert @expected == Sandbox.clear_positions()
    end

    @response Response.new(%{
                "trackingId" => "1234",
                "status" => "Ok",
                "payload" => %{
                  "currency" => "USD",
                  "balance" => 355.55
                },
                "status_code" => 200
              })
    @expected %Response{
      payload:
        Model.Currency.Balance.new(%{
          "currency" => "USD",
          "balance" => 355.55
        }),
      tracking_id: "1234",
      status: "Ok",
      status_code: 200
    }
    http_mock "Set currencies balance" do
      assert @expected == Sandbox.set_currency_balance("USD", 355.55)
    end

    @response Response.new(%{
                "trackingId" => "1234",
                "status" => "Ok",
                "payload" => %{
                  "figi" => "AAPL",
                  "balance" => 355.55
                },
                "status_code" => 200
              })
    @expected %Response{
      payload:
        Model.Position.Balance.new(%{
          "figi" => "AAPL",
          "balance" => 355.55
        }),
      tracking_id: "1234",
      status: "Ok",
      status_code: 200
    }
    http_mock "Set positions balance" do
      assert @expected == Sandbox.set_position_balance("AAPL", 355.55)
    end
  end
end

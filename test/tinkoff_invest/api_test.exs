defmodule TinkoffInvestTest.ApiTest do
  use ExUnit.Case
  doctest TinkoffInvest
  alias TinkoffInvest.Api

  describe "Api" do
    test "Build request payload adds brokerAccountId query field" do
      path = "/orders"
      figi = "123"
      account_id = Application.fetch_env!(:tinkoff_invest, :broker_account_id)
      expected = path <> "?brokerAccountId=#{account_id}&figi=#{figi}"
      assert expected == Api.build_payload(path, %{figi: figi})
    end

    test "Parse datetime to iso string" do
      path = "/orders"
      figi = "123"
      from = DateTime.now!("Etc/UTC")

      iso_from =
        from
        |> DateTime.to_iso8601()
        |> URI.encode_www_form()

      account_id = Application.fetch_env!(:tinkoff_invest, :broker_account_id)
      expected = path <> "?brokerAccountId=#{account_id}&figi=#{figi}&from=#{iso_from}"
      assert expected == Api.build_payload(path, %{figi: figi, from: from})
    end

    test "User can overwrite default brokerAccountId" do
      path = "/orders"
      figi = "123"
      account_id = Application.fetch_env!(:tinkoff_invest, :broker_account_id)
      new_account_id = account_id <> "564"
      expected = path <> "?brokerAccountId=#{new_account_id}&figi=#{figi}"
      assert expected == Api.build_payload(path, %{figi: figi, brokerAccountId: new_account_id})
    end
  end
end

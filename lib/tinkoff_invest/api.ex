defmodule TinkoffInvest.Api do
  @moduledoc """
  This module provides two simple requests: GET and POST

  `payload` map converted to query string on request 

  You will need to define your custom `TinkoffInvest.Model` to make this work or use existing one.

  Examples: 

  ```
  TinkoffInvest.Api.request("/orders", :get, YourCustomModel)
  TinkoffInvest.Api.request("/orders", :get, YourCustomModel, %{someParam: true}) # /orders?someParam=true
  TinkoffInvest.Api.request("/orders", :post, YourCustomModel, %{})
  ```
  """
  alias TinkoffInvest.Api.Request
  alias TinkoffInvest.Model.Api.Response

  def request(path, method, module, payload \\ nil)
  def request(path, :get, module, payload), do: get(path, module, payload)
  def request(path, :post, module, payload), do: post(path, module, payload)

  defp get(path, module, payload) do
    path
    |> build_query(payload)
    |> Request.get()
    |> handle_response(module)
  end

  defp post(path, module, payload) do
    path
    |> build_query(payload)
    |> Request.post("")
    |> handle_response(module)
  end

  defp handle_response({:ok, resp}, module), do: handle_response(resp, module)

  defp handle_response(%Response{status_code: status_code} = data, _)
       when status_code in [401, 404, 500] do
    data
  end

  defp handle_response(%Response{payload: payload} = data, module) do
    payload
    |> module.new()
    |> Response.payload(data)
  end

  defp build_query(path, nil), do: path

  defp build_query(path, payload) do
    payload
    |> Enum.map(&build_query_field/1)
    |> List.insert_at(0, path)
    |> Enum.join()
  end

  defp build_query_field({_, nil}), do: ""
  defp build_query_field({:account_id, _}), do: account_id_query()

  defp build_query_field({field, %DateTime{} = datetime}) do
    value = DateTime.to_iso8601(datetime)
    "&#{field}=#{value}"
  end

  defp build_query_field({field, value}), do: "&#{field}=#{value}"

  defp account_id_query, do: "&brokerAccountId=#{account_id()}"

  defp account_id do
    Application.fetch_env!(:tinkoff_invest, :broker_account_id)
  end
end

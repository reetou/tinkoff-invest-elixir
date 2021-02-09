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
  alias TinkoffInvest.Model.Api.Error

  @type method() :: :get | :post

  @doc """
  Allows you to send request to api if you need custom method that is not currently implemented
  """
  @spec request(String.t(), method(), module(), map() | nil) :: Response.t()
  def request(path, method, module, payload \\ nil)
  def request(path, :get, module, payload), do: get(path, module, payload)
  def request(path, :post, module, payload), do: post(path, module, payload)

  @doc """
  Builds payload from map. Account id provided by default in config though can be overridden

  Examples 
  ```
  # Overwrites default value in config
  TinkoffInvest.Api.build_payload("/orders", %{brokerAccountId: "MyCustomId"})
  # Adds brokerAccountId field with broker_account_id from config to payload
  TinkoffInvest.Api.build_payload("/orders", %{figi: "AAPL"})
  ```
  """
  @spec build_payload(String.t(), map() | nil) :: String.t()
  def build_payload(path, payload) do
    path
    |> build_query(payload)
  end

  def to_response(%HTTPoison.Response{status_code: status_code, body: nil}) do
    %{
      "status_code" => status_code,
      "payload" => %{"code" => nil, "message" => nil}
    }
    |> Response.new()
  end

  def to_response(%HTTPoison.Response{status_code: status_code, body: body}) do
    Response.new(Map.put(body, "status_code", status_code))
  end

  defp get(path, module, payload) do
    path
    |> build_payload(payload)
    |> Request.get()
    |> handle_response(module)
  end

  defp post(path, module, payload) do
    path
    |> build_payload(payload)
    |> Request.post("")
    |> handle_response(module)
  end

  defp handle_response({:ok, resp}, module), do: handle_response(resp, module)

  defp handle_response(%Response{payload: %{"code" => _} = error} = data, _) do
    error
    |> Error.new()
    |> Response.payload(data)
  end

  defp handle_response(%Response{payload: payload} = data, module) do
    payload
    |> module.new()
    |> Response.payload(data)
  end

  defp build_query(path, nil), do: path

  defp build_query(path, payload) do
    payload
    |> maybe_overwrite_account_id()
    |> encode_query()
    |> List.wrap()
    |> List.insert_at(0, "?")
    |> List.insert_at(0, path)
    |> Enum.join()
  end

  defp encode_query(payload) do
    payload
    |> Enum.map(&build_query_field/1)
    |> Map.new()
    |> URI.encode_query()
  end

  defp build_query_field({field, %DateTime{} = datetime}) do
    value = datetime |> DateTime.to_iso8601()
    {field, value}
  end

  defp build_query_field(x), do: x

  defp maybe_overwrite_account_id(%{brokerAccountId: _} = payload), do: payload

  defp maybe_overwrite_account_id(payload) do
    Map.put(payload, :brokerAccountId, account_id())
  end

  defp account_id do
    Application.fetch_env!(:tinkoff_invest, :broker_account_id)
  end
end

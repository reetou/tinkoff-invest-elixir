defmodule TinkoffInvest.Api do
  @moduledoc """
  This module provides two simple requests: GET and POST

  `payload` map converted to query string on request 

  You will need to define your custom `TinkoffInvest.Model` to make this work or use existing one.

  Examples: 

  ```
  TinkoffInvest.Api.request("/orders", :get, YourCustomModel)
  TinkoffInvest.Api.request("/orders", :get, YourCustomModel, %{someQueryParam: true}) # /orders?someParam=true
  TinkoffInvest.Api.request("/orders", :post, YourCustomModel, %{someQueryParam: true})
  TinkoffInvest.Api.request("/orders", :post, YourCustomModel, %{someQueryParam: true}, %{bodyParam: true})

  ```

  Please notice that `:post` request accepts both query and body payloads preferably as maps
  """
  alias TinkoffInvest.Api.Request
  alias TinkoffInvest.Model.Api.Response
  alias TinkoffInvest.Model.Api.Error

  @type method() :: :get | :post

  @doc """
  Allows you to send request to api if you need custom method that is not currently implemented
  """
  @spec request(String.t(), method(), module(), map() | nil, map() | nil) :: Response.t()
  def request(path, method, module, queryPayload \\ nil, body \\ %{})
  def request(path, :get, module, queryPayload, _), do: get(path, module, queryPayload)
  def request(path, :post, module, queryPayload, body), do: post(path, module, queryPayload, body)

  @doc """
  Builds query payload from map. Account id provided by default in config though can be overridden

  Examples 

      iex>TinkoffInvest.change_account_id("123")
      :ok
      iex>TinkoffInvest.Api.build_payload("/orders", %{myQueryParam: true, someOtherParam: 2})
      "/orders?brokerAccountId=123&myQueryParam=true&someOtherParam=2"

  You can override broker account id:    

      iex>TinkoffInvest.Api.build_payload("/orders", %{brokerAccountId: "SB1111", myQueryParam: true, someOtherParam: 2})
      "/orders?brokerAccountId=SB1111&myQueryParam=true&someOtherParam=2"
  """
  @spec build_payload(String.t(), map() | nil) :: String.t()
  def build_payload(path, payload) do
    path
    |> build_query(payload)
  end

  @doc """
  Build body payload and encodes it to JSON if needed. 

      iex>TinkoffInvest.Api.build_body_payload(nil)
      ""

      iex>TinkoffInvest.Api.build_body_payload("[123]")
      "[123]"

      iex>TinkoffInvest.Api.build_body_payload(%{myField: true})
      "{\\"myField\\":true}"

  """
  @spec build_body_payload(map() | nil | String.t()) :: String.t()
  def build_body_payload(nil), do: ""

  def build_body_payload(payload) when is_binary(payload), do: payload

  def build_body_payload(payload) when is_map(payload) do
    Jason.encode!(payload)
  end

  @doc """

  Transforms body response and encodes it to `TinkoffInvest.Model.Api.Response` 

      iex>TinkoffInvest.Api.to_response(%HTTPoison.Response{body: "SOME_ERROR", status_code: 404, request: %HTTPoison.Request{url: "/orders"}})
      %TinkoffInvest.Model.Api.Response{payload: %{"code" => nil, "message" => "SOME_ERROR"}, request_url: "/orders", status: nil, status_code: 404, tracking_id: nil}

      iex>TinkoffInvest.Api.to_response(%HTTPoison.Response{body: nil, status_code: 404, request: %HTTPoison.Request{url: "/orders"}})
      %TinkoffInvest.Model.Api.Response{payload: %{"code" => nil, "message" => nil}, request_url: "/orders", status: nil, status_code: 404, tracking_id: nil}

      iex>TinkoffInvest.Api.to_response(%HTTPoison.Response{body: %{"payload" => %{"code" => "SOME_ERR", "message" => "Well, error"}}, status_code: 404, request: %HTTPoison.Request{url: "/orders"}})
      %TinkoffInvest.Model.Api.Response{payload: %{"code" => "SOME_ERR", "message" => "Well, error"}, request_url: "/orders", status: nil, status_code: 404, tracking_id: nil}

  """
  def to_response(%HTTPoison.Response{body: body, status_code: status_code} = r)
      when is_binary(body) and status_code not in [200] do
    r
    |> Map.put(:body, %{"payload" => %{"code" => nil, "message" => body}})
    |> to_response()
  end

  def to_response(%HTTPoison.Response{body: nil} = r) do
    %{
      "payload" => %{"code" => nil, "message" => nil}
    }
    |> response_metadata(r)
    |> Response.new()
  end

  def to_response(%HTTPoison.Response{body: body} = r) do
    body
    |> response_metadata(r)
    |> Response.new()
  end

  defp response_metadata(data, %HTTPoison.Response{
         status_code: code,
         request: %HTTPoison.Request{url: url}
       }) do
    data
    |> Map.put("status_code", code)
    |> Map.put("request_url", url)
  end

  defp get(path, module, payload) do
    path
    |> build_payload(payload)
    |> Request.get()
    |> handle_response(module)
  end

  defp post(path, module, payload, body) do
    body = build_body_payload(body)

    path
    |> build_payload(payload)
    |> Request.post(body)
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

  defp build_query(path, nil), do: build_query(path, %{})

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

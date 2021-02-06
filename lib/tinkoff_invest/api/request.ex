defmodule TinkoffInvest.Api.Request do
  use HTTPoison.Base
  alias TinkoffInvest.Api
  require Logger

  def process_url(url) do
    TinkoffInvest.endpoint() <> url
  end

  def process_response_body(""), do: nil

  def process_response_body(body) when is_binary(body) do
    case Jason.decode(body) do
      {:ok, jsonBody} -> jsonBody
      _ -> body
    end
  end

  def process_request_headers(headers) do
    headers ++ custom_headers()
  end

  def process_response(%HTTPoison.Response{} = r) do
    r
    |> log()
    |> Api.to_response()
  end

  defp log(response) do
    if TinkoffInvest.logs_enabled?() do
      Logger.debug("Response: #{inspect(response)}")
    end

    response
  end

  defp token do
    Application.fetch_env!(:tinkoff_invest, :token)
  end

  defp custom_headers do
    [
      {"authorization", "Bearer " <> token()},
      {"accept", "application/json"}
    ]
  end
end

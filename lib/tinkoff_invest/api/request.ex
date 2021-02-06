defmodule TinkoffInvest.Api.Request do
  use HTTPoison.Base
  alias TinkoffInvest.Model.Api.Error
  alias TinkoffInvest.Model.Api.Response

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

  def process_response(%HTTPoison.Response{status_code: status_code, body: body})
      when status_code in [401, 404, 500] do
    Response.new(%{
      "status_code" => status_code,
      "payload" =>
        body
        |> handle_error_message(status_code)
        |> Error.new()
    })
  end

  def process_response(%HTTPoison.Response{status_code: status_code, body: body}) do
    Response.new(Map.put(body, "status_code", status_code))
  end

  defp handle_error_message(nil, 401), do: %{"message" => "Not authorized"}
  defp handle_error_message(nil, 500), do: %{"message" => "Internal Server Error"}
  defp handle_error_message(message, _) when is_binary(message), do: %{"message" => message}
  defp handle_error_message(%{"payload" => payload}, _), do: payload
  defp handle_error_message(x, _), do: x

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

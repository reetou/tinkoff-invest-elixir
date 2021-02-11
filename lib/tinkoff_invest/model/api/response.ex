defmodule TinkoffInvest.Model.Api.Response do
  use TypedStruct

  typedstruct do
    field(:status, String.t(), enforce: true)
    field(:tracking_id, String.t(), enforce: true)
    field(:payload, term())
    field(:status_code, integer(), enforce: true)
    field(:request_url, String.t())
  end

  def new(
        %{
          "trackingId" => tracking_id,
          "status" => status,
          "payload" => payload,
          "status_code" => status_code
        } = params
      ) do
    %__MODULE__{
      tracking_id: tracking_id,
      status: status,
      payload: payload,
      status_code: status_code,
      request_url: Map.get(params, "request_url")
    }
  end

  def new(
        %{
          "status_code" => status_code,
          "payload" => payload
        } = params
      ) do
    %__MODULE__{
      tracking_id: nil,
      status: nil,
      status_code: status_code,
      payload: payload,
      request_url: Map.get(params, "request_url")
    }
  end

  def payload(data, response) do
    %__MODULE__{response | payload: data}
  end
end

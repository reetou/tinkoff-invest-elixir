defmodule TinkoffInvest do
  @moduledoc """
  Convenient functions for frequent use-cases
  """

  @type mode() :: :sandbox | :production

  @default_endpoint "https://api-invest.tinkoff.ru/openapi"

  alias TinkoffInvest.Portfolio
  alias TinkoffInvest.User
  alias TinkoffInvest.Orders
  alias TinkoffInvest.Model.Api.Response

  @doc delegate_to: {User, :accounts, 0}
  defdelegate accounts, to: User

  @doc delegate_to: {Orders, :active_orders, 0}
  defdelegate active_orders, to: Orders

  @doc delegate_to: {Orders, :create_limit_order, 1}
  defdelegate create_limit_order(figi), to: Orders

  @doc delegate_to: {Orders, :create_market_order, 1}
  defdelegate create_market_order(figi), to: Orders

  @doc delegate_to: {Orders, :cancel_order, 1}
  defdelegate cancel_order(order_id), to: Orders

  @doc delegate_to: {Portfolio, :full, 0}
  defdelegate portfolio, to: Portfolio, as: :full

  @doc """
  Change broker account id. 
  Useful when wanna switch between accounts dynamically.
  """
  @spec change_account_id(String.t()) :: :ok
  def change_account_id(id) do
    Application.put_env(:tinkoff_invest, :broker_account_id, id)
  end

  @doc """
  Change token dynamically without restarting app. 
  Useful when using multiple broker accounts on different clients
  """
  @spec change_token(String.t()) :: :ok
  def change_token(token) do
    Application.put_env(:tinkoff_invest, :token, token)
  end

  @doc """
  Change mode dynamically.
  """
  @spec set_mode(mode()) :: mode()
  def set_mode(mode) when mode in [:sandbox, :production] do
    Application.put_env(:tinkoff_invest, :mode, mode)
  end

  @doc """
  Returns current mode 
  """
  @spec mode :: mode()
  def mode do
    Application.fetch_env!(:tinkoff_invest, :mode)
  end

  @doc """
  Returns API endpoint for current mode
  """
  @spec endpoint :: String.t()
  def endpoint do
    Application.get_env(:tinkoff_invest, :endpoint, @default_endpoint) <> endpoint_prefix()
  end

  @doc """
  Takes payload from response and returns it, useful for piping
  """
  @spec payload(Response.t()) :: term()
  def payload(%Response{payload: payload}), do: payload

  defp endpoint_prefix do
    case TinkoffInvest.mode() do
      :sandbox -> "/sandbox"
      :production -> ""
    end
  end
end

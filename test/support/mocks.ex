defmodule TinkoffInvest.TestMocks do
  alias TinkoffInvest.Api.Request

  defmacro http_mock(name, test) do
    mod = Request
    opts = []
    fun_name = Macro.escape(:"#{name}")
    caller = __CALLER__.module

    mocks = [
      get: Function.capture(caller, fun_name, 1),
      post: Function.capture(caller, fun_name, 2)
    ]

    quote do
      def unquote(fun_name)(url) do
        @response
      end

      def unquote(fun_name)(url, payload) do
        @response
      end

      test unquote(name) do
        with_mock(
          unquote(mod),
          unquote(opts),
          unquote(mocks),
          unquote(test)
        )
      end
    end
  end
end

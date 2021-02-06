defmodule TinkoffInvest.Model.Candle do
  use TypedStruct

  typedstruct enforce: true do
    field(:figi, String.t())
    field(:interval, String.t())
    field(:o, float())
    field(:c, float())
    field(:h, float())
    field(:l, float())
    field(:v, float())
    field(:time, String.t())
  end

  def new(%{"candles" => x}) when is_list(x), do: Enum.map(x, &new/1)

  def new(%{
        "figi" => figi,
        "interval" => interval,
        "o" => o,
        "c" => c,
        "h" => h,
        "l" => l,
        "v" => v,
        "time" => time
      }) do
    %__MODULE__{
      figi: figi,
      interval: interval,
      o: o,
      c: c,
      h: h,
      l: l,
      v: v,
      time: time
    }
  end
end

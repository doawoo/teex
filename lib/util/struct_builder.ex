defmodule Teex.Util.StructBuilder do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      import Teex.Util.StructBuilder
    end
  end

  defmacro builder() do
    quote generated: true do
      def build(attrs) do
        filtered = Enum.filter(attrs, fn {_k, v} -> !is_nil(v) end)
        struct(unquote(__CALLER__.module), filtered)
      end
    end
  end
end

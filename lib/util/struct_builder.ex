defmodule Tex.Util.StructBuilder do
  defmacro __using__(_opts) do
    quote do
      import Tex.Util.StructBuilder
    end
  end

  defmacro builder() do
    quote generated: true do
      def build(attrs) do
        filtered = Enum.filter(attrs, fn {_k, v} -> !is_nil(v) end)
        {:ok, struct(unquote(__CALLER__.module), filtered)}
      end
    end
  end
end

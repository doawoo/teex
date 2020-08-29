defmodule TexTest do
  use ExUnit.Case
  doctest Tex

  test "greets the world" do
    assert Tex.hello() == :world
  end
end

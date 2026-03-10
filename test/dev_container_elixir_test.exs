defmodule DevContainerElixirTest do
  use ExUnit.Case
  doctest DevContainerElixir

  test "greets the world" do
    assert DevContainerElixir.hello() == :world
  end
end

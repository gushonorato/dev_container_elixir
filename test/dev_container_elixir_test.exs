defmodule DevContainerElixirTest do
  use ExUnit.Case

  test "module exists" do
    assert Code.ensure_loaded?(DevContainerElixir)
  end
end

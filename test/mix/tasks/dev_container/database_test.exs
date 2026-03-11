defmodule Mix.Tasks.DevContainer.DatabaseTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  describe "run/1" do
    test "prints the default container name" do
      output = capture_io(fn -> Mix.Tasks.DevContainer.Database.run([]) end)
      assert output =~ "dev_container_elixir_dev"
    end
  end
end

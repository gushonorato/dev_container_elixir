defmodule Mix.Tasks.DevContainer.DatabaseTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  describe "run/1" do
    test "prints the default container name" do
      output = capture_io(fn -> Mix.Tasks.DevContainer.Database.run([]) end)
      dir = Mix.Project.project_file() |> Path.dirname() |> Path.basename()
      assert output =~ "dev_container_elixir.#{dir}"
    end
  end
end

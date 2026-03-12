defmodule Mix.Tasks.DevContainer.DockerTest do
  use ExUnit.Case

  alias Mix.Tasks.DevContainer.Docker

  describe "compose_file/0" do
    test "returns path ending with docker-compose.dev.yml" do
      assert Docker.compose_file() |> Path.basename() == "docker-compose.dev.yml"
    end

    test "returns an absolute path" do
      assert Docker.compose_file() |> Path.type() == :absolute
    end
  end

  describe "default_name/0" do
    test "returns app_name.dirname format" do
      dir = Mix.Project.project_file() |> Path.dirname() |> Path.basename()
      assert Docker.default_name() == "dev_container_elixir.#{dir}"
    end
  end

  describe "env/1" do
    test "returns expected environment variable tuples" do
      env = Docker.env("my_container")

      assert {"APP_NAME", "dev_container_elixir"} in env
      assert {"CONTAINER_NAME", "my_container"} in env
      assert {"DATABASE", "my_container"} in env
    end

    test "includes APP_SRC_PATH" do
      env = Docker.env("test")
      assert Enum.any?(env, fn {key, _} -> key == "APP_SRC_PATH" end)
    end
  end
end

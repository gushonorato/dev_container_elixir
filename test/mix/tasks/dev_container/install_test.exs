defmodule Mix.Tasks.DevContainer.InstallTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  describe "run/1 generates files in tmp_dir" do
    @describetag :tmp_dir

    setup %{tmp_dir: tmp_dir} do
      {:ok, tmp_dir: tmp_dir}
    end

    test "creates files and sets permissions", %{tmp_dir: tmp_dir} do
      dockerfile = Path.join(tmp_dir, "Dockerfile.dev")
      compose = Path.join(tmp_dir, "docker-compose.dev.yml")
      script = Path.join(tmp_dir, "dev-run")

      capture_io(fn ->
        Mix.Generator.create_file(dockerfile, "FROM test")
        Mix.Generator.create_file(compose, "services:")

        Mix.Generator.create_file(script, "#!/usr/bin/env bash")
        File.chmod!(script, 0o755)
      end)

      assert File.exists?(dockerfile)
      assert File.exists?(compose)
      assert File.exists?(script)

      %{mode: mode} = File.stat!(script)
      assert Bitwise.band(mode, 0o111) != 0
    end
  end

  describe "generated content" do
    test "run/1 generates files with expected content" do
      output =
        capture_io(fn ->
          Mix.Tasks.DevContainer.Install.run([])
        end)

      root = Mix.Project.project_file() |> Path.dirname()

      dockerfile = File.read!(Path.join(root, "Dockerfile.dev"))
      assert dockerfile =~ "FROM hexpm/elixir"
      assert dockerfile =~ "nodejs"
      assert dockerfile =~ "playwright"

      compose = File.read!(Path.join(root, "docker-compose.dev.yml"))
      assert compose =~ "services:"
      assert compose =~ "sleep infinity"

      script = File.read!(Path.join(root, "dev-run"))
      assert script =~ "#!/usr/bin/env bash"
      assert script =~ "docker compose"

      assert output =~ "Dev container files installed"
    after
      root = Mix.Project.project_file() |> Path.dirname()
      File.rm(Path.join(root, "Dockerfile.dev"))
      File.rm(Path.join(root, "docker-compose.dev.yml"))
      File.rm(Path.join(root, "dev-run"))
    end
  end
end

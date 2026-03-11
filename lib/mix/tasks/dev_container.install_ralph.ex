defmodule Mix.Tasks.DevContainer.InstallRalph do
  @shortdoc "Installs Ralph agent scripts into the project"
  @moduledoc """
  Downloads Ralph agent files from GitHub into `scripts/ralph/`:

    * `ralph.sh` — long-running AI agent loop
    * `CLAUDE.md` — agent instructions for Claude Code

      mix dev_container.install_ralph
  """

  use Mix.Task

  @ralph_repo_base "https://raw.githubusercontent.com/snarktank/ralph/main"
  @files ["ralph.sh", "CLAUDE.md"]

  @impl Mix.Task
  def run(_args) do
    root = Mix.Project.project_file() |> Path.dirname()
    ralph_dir = Path.join(root, "scripts/ralph")
    File.mkdir_p!(ralph_dir)

    Enum.each(@files, fn file ->
      url = "#{@ralph_repo_base}/#{file}"
      dest = Path.join(ralph_dir, file)

      Mix.shell().info("Downloading #{file}...")

      case System.cmd("curl", ["-fsSL", url], stderr_to_stdout: true) do
        {body, 0} ->
          File.write!(dest, body)
          Mix.shell().info("  -> #{Path.relative_to_cwd(dest)}")

        {output, _} ->
          Mix.raise("Failed to download #{url}: #{output}")
      end
    end)

    # Make ralph.sh executable
    File.chmod!(Path.join(ralph_dir, "ralph.sh"), 0o755)

    Mix.shell().info("""
    \nRalph agent installed in scripts/ralph/.

    Ensure the Claude Code plugin is installed:

        /plugin install ralph-skills@ralph-marketplace
    """)
  end
end

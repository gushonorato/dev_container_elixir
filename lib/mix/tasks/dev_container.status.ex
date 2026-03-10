defmodule Mix.Tasks.DevContainer.Status do
  @shortdoc "Shows running dev container metadata"
  @moduledoc """
  Shows metadata from all running dev Docker containers.

      mix dev_container.status

  Reads labels set on each container at start time.
  """

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    case find_containers() do
      [] ->
        Mix.shell().error("No running dev containers found")

      container_ids ->
        container_ids
        |> Enum.with_index(1)
        |> Enum.each(fn {container_id, index} ->
          labels = read_labels(container_id)

          if index > 1, do: Mix.shell().info("")

          Mix.shell().info("Container ##{index}")
          Mix.shell().info("  App name:   #{labels["dev.app_name"]}")
          Mix.shell().info("  Container:  #{labels["dev.container_name"]}")
          Mix.shell().info("  Database:   #{labels["dev.database"]}")
          Mix.shell().info("  Src path:   #{labels["dev.src_path"]}")
        end)
    end
  end

  defp find_containers do
    case System.cmd("docker", ["ps", "-q", "--filter", "label=dev.app_name"]) do
      {output, 0} ->
        output |> String.trim() |> String.split("\n", trim: true)

      _ ->
        []
    end
  end

  defp read_labels(container_id) do
    case System.cmd("docker", ["inspect", "--format", "{{json .Config.Labels}}", container_id]) do
      {output, 0} -> output |> String.trim() |> Jason.decode!()
      _ -> %{}
    end
  end
end

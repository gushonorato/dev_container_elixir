defmodule DevContainerElixir.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/gushonorato/dev_container_elixir"

  def project do
    [
      app: :dev_container_elixir,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description:
        "Mix tasks for managing Docker-based development containers in Elixir/Phoenix projects.",
      package: package(),
      source_url: @source_url,
      docs: [
        main: "readme",
        extras: ["README.md", "LICENSE"]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.4"},
      {:ex_doc, "~> 0.35", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end
end

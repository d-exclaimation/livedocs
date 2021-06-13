defmodule Livedocs.MixProject do
  use Mix.Project

  def project do
    [
      app: :livedocs,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Livedocs, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:cors_plug, "~> 2.0"},
      {:cowboy, "~> 2.9"},
      {:plug, "~> 1.11"},
      {:plug_cowboy, "~> 2.5"},
      {:jason, "~> 1.2"}
    ]
  end
end

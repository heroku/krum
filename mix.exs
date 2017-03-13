defmodule Krum.Mixfile do
  use Mix.Project

  def project do
    [app: :krum,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp deps do
    [{:poison, "~> 3.1"},
     {:httpoison, "~> 0.11"},
     {:mock, "~> 0.2", only: :test}]
  end
end

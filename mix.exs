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
    [{:poison, "~> 2.1"},
     {:httpoison, "~> 0.8.2"},
     {:mock, "~> 0.1.3", only: :test}]
  end
end

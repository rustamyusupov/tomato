defmodule Tomato.MixProject do
  use Mix.Project

  def project do
    [
      app: :tomato,
      version: "0.2.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      escript: escript(),
      deps: deps()
    ]
  end

  def application do
    [
      application: [:timex, :httpoison, :logger]
    ]
  end

  defp deps do
    [
      {:progress_bar, "> 0.0.0"},
      {:poison, "~> 3.1"},
      {:httpoison, "~> 1.4"}
    ]
  end

  defp escript do
    [main_module: Tomato.CLI]
  end
end

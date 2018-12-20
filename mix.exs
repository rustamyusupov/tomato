defmodule Tomato.MixProject do
  use Mix.Project

  def project do
    [
      app: :tomato,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      escript: escript(),
      deps: deps()
    ]
  end

  def application do
    [
      application: [:timex, :logger],
    ]
  end

  defp deps do
    [
      {:progress_bar, "> 0.0.0"},
      {:timex, "~> 3.1"},
      {:tzdata, "~> 0.1.7", override: true},
    ]
  end

  defp escript do
    [main_module: Tomato.CLI]
  end
end

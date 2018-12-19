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

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:progress_bar, "> 0.0.0"},
    ]
  end

  defp escript do
    [main_module: Tomato.CLI]
  end
end

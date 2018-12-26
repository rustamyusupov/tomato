defmodule Tomato.Token do
  alias Tomato.Slack

  def check(token) do
    Slack.check_auth(token)
  end

  def prompt do
    "Input slack token: "
    |> IO.gets
    |> String.trim()
  end
end

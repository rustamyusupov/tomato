defmodule Tomato.Token do
  alias Tomato.Slack

  def init(token) do
    if !check(token) do
      IO.puts("Token invalid.")
      token = prompt()
      IO.puts("")

      init(token)
    else
      token
    end
  end

  defp check(token) do
    Slack.check_auth(token)["ok"]
  end

  defp prompt do
    "Input slack token: "
    |> IO.gets()
    |> String.trim()
  end
end

defmodule Tomato.Status do
  def set(text, emoji) do
    url = get_url()

    headers = [
      {"Content-type", "application/json; charset=utf-8"},
      {"Authorization", "Bearer xoxp-2183023374-124945812292-480298980756-d5d9b579e995a6d171706a7942ab34d4"}
    ]

    body = %{
      profile: %{
        status_text: text,
        status_emoji: get_emoji(emoji),
      }
    } |> Poison.encode!

    IO.puts body

    {:ok, response} = HTTPoison.post(url, body, headers, [])
    # IO.inspect response.body |> Poison.decode
  end

  def clear do
    set("", "")
  end

  defp get_url do
    api = "https://slack.com/api/"
    method = "users.profile.set"

    "#{api}#{method}"
  end

  defp get_emoji(str) do
    if str != "", do: ":#{str}:", else: ""
  end
end

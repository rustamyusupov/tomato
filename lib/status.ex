defmodule Tomato.Status do
  def set(text, emoji) do
    token = "xoxp-2183023374-124945812292-510851594439-95e3a95bb531f7d94e744e175e2bccd2"
    url = get_url()
    body = get_body(text, emoji)
    headers = get_headers(token)

    request(url, body, headers)
  end

  def clear do
    set("", "")
  end

  defp request(url, body, headers) do
    case HTTPoison.post(url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        nil
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  defp get_url do
    api = "https://slack.com/api/"
    method = "users.profile.set"

    "#{api}#{method}"
  end

  defp get_body(text, emoji) do
    %{
      profile: %{
        status_text: text,
        status_emoji: get_emoji(emoji),
      }
    } |> Poison.encode!
  end

  defp get_emoji(str) do
    if str != "", do: ":#{str}:", else: ""
  end

  def get_headers(token) do
    %{
      "Content-Type" => "application/json; charset=utf-8",
      "Accept" => "application/json",
      "Authorization" => "Bearer #{token}"
    }
  end
end

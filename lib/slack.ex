defmodule Tomato.Slack do
  alias Tomato.Request

  def check_auth(token) do
    url = get_url("auth.test")
    headers = get_headers(token)

    Request.post(url, [], headers)
  end

  def set_status(token, emoji \\ "", text \\ "", expiration \\ 0) do
    url = get_url("users.profile.set")
    body = get_profile_body(emoji, text, expiration)
    headers = get_headers(token)

    Request.post(url, body, headers)
    |> print_request_error
  end

  def set_presence(token, presence \\ "auto") do
    url = get_url("users.setPresence")
    body = get_presence_body(presence)
    headers = get_headers(token)

    Request.post(url, body, headers)
    |> print_request_error
  end

  defp get_url(endpoint) do
    "https://slack.com/api/" <> endpoint
  end

  defp get_profile_body(emoji, text, expiration) do
    %{
      profile: %{
        status_emoji: emoji,
        status_text: text,
        status_expiration: expiration
      }
    }
    |> Poison.encode!()
  end

  defp get_presence_body(presence) do
    %{
      presence: presence
    }
    |> Poison.encode!()
  end

  def get_headers(token) do
    %{
      "Content-Type": "application/json; charset=utf-8",
      Accept: "application/json",
      Authorization: "Bearer #{token}"
    }
  end

  defp print_request_error(response) do
    response["error"] && IO.puts(response["error"])
  end
end

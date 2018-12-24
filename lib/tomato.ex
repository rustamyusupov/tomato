defmodule Tomato.CLI do
  alias Tomato.Config
  alias Tomato.Slack
  alias Tomato.Progress

  @help [
    "Tomato is a tool for set slack status and presence\n",
    "Usage: tomato [parameters]\n",
    "Parameters:",
    "  -e - Emoji: status emoji",
    "  -t - Text: status text",
    "  -p - Presence: auto | away",
    "  -d - Duration: how long set status in minutes",
    "  -s - Say: command say phrase at the end"
  ]
  @miliseconds_in_minutes 1000 * 60

  def main(args \\ []) do
    args
    |> parse_args
    |> Config.init
    |> process
  end

  defp parse_args(args) do
    {opts, _, _} =
      args
      |> OptionParser.parse(
        strict: [emoji: :string, text: :string, duration: :integer, presence: :string, say: :string],
        aliases: [e: :emoji, t: :text, d: :duration, p: :presence, s: :say]
      )

    opts
  end

  defp process(params) do
    token = params[:token]
    emoji = params[:emoji]
    text = params[:text]
    duration = params[:duration]
    presence = params[:presence]
    say = params[:say]
    timezone = params[:timezone] || 0

    cond do
      !token ->
        IO.puts "Token not set in environment variable"

      (emoji || text || presence) ->
        expiration = get_expiration(timezone, duration)

        Slack.set_status(token, emoji, text, expiration)
        presence && Slack.set_presence(token, presence)
        duration && Progress.start(duration * @miliseconds_in_minutes)
        duration && Slack.set_status(token)
        presence && duration && Slack.set_presence(token)
        duration && say && say_finished(say)

      duration ->
        IO.puts "Nothing to do"

      true ->
        show_help()
    end
  end

  defp get_expiration(timezone, duration) do
    case duration do
      nil -> 0
      _ ->
        Timex.now(timezone)
        |> Timex.shift(minutes: duration)
        |> Timex.to_unix()
    end
  end

  defp show_help do
    Enum.each(@help, fn line -> IO.puts line end)
  end

  defp say_finished(say) do
    System.cmd("say", [say])
  end
end

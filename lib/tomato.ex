defmodule Tomato.CLI do
  alias Tomato.Config
  alias Tomato.Slack
  alias Tomato.Progress

  @config_filename "./config.json"
  @default_sound "doom.wav"
  @help [
    "Tomato is a tool for set slack status and presence\n",
    "Usage: tomato [parameters]\n",
    "Parameters:",
    "  -e - Emoji",
    "  -t - Text",
    "  -p - Presence: auto | away",
    "  -d - Duration: how long set status in minutes"
  ]

  def main(args \\ []) do
    args
    |> parse_args
    |> Config.init(@config_filename)
    |> process
  end

  defp parse_args(args) do
    {opts, _, _} =
      args
      |> OptionParser.parse(
        strict: [emoji: :string, text: :string, duration: :integer, presence: :string],
        aliases: [e: :emoji, t: :text, d: :duration, p: :presence]
      )

    opts
  end

  defp process(params) do
    token = params[:token]
    emoji = params[:emoji]
    text = params[:text]
    presence = (params[:presence] == "auto" || params[:presence] == "away") && params[:presence] || false
    duration = params[:duration]

    cond do
      !token ->
        IO.puts "Token not set -> config.json"

      ((emoji || text || presence) && duration) ->
        until = get_time(params[:timezone] || 0, duration)
        message = "#{text} #{until}"
        Slack.set_status(token, emoji, message)
        presence && Slack.set_presence(token, presence)

        Progress.start(duration)

        Slack.set_status(token, "", "")
        presence && Slack.set_presence(token, !presence)

      (emoji || text || presence) ->
        Slack.set_status(token, emoji, text)
        presence && Slack.set_presence(token, presence)

      duration ->
        IO.puts "Nothing to do"

      true ->
        show_help()
    end
  end

  defp show_help do
    Enum.each(@help, fn line -> IO.puts line end)
  end

  defp get_time(timezone, duration) do
    Timex.now(timezone)
    |> Timex.shift(minutes: duration)
    |> Timex.format!("{h24}:{m}")
  end
end

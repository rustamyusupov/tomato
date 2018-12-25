defmodule Tomato.CLI do
  alias Tomato.Config
  alias Tomato.Slack
  alias Tomato.Progress

  @help [
    "Tomato is a tool for set slack status and presence\n",
    "Usage: tomato [parameters]\n",
    "Parameters:",
    "  -e - emoji: status emoji",
    "  -t - text: status text",
    "  -p - presence: auto | away",
    "  -d - duration: how long set status in minutes",
    "  -s - say: command say phrase at the end"
  ]
  @miliseconds_in_minutes 1000 # * 60

  def main(args \\ []) do
    args
    |> parse_args
    |> process
  end

  defp parse_args(args) do
    {opts, _, _} =
      args
      |> OptionParser.parse(
        strict: [
          help: :boolean,
          emoji: :string,
          text: :string,
          duration: :integer,
          presence: :string,
          say: :string
        ],
        aliases: [h: :help, e: :emoji, t: :text, d: :duration, p: :presence, s: :say]
      )

    opts
  end

  defp process([]) do
    IO.puts "no args"
  end

  defp process(options) do
    params = Config.init(options)
    token = params[:token]
    help = params[:help]
    emoji = params[:emoji]
    text = params[:text]
    duration = params[:duration]
    presence = params[:presence]
    say = params[:say]
    timezone = params[:timezone] || 0

    cond do
      !token ->
        IO.puts("Token not set in environment variable")

      help ->
        show_help()

      emoji || text || presence ->
        expiration = get_expiration(timezone, duration)

        Slack.set_status(token, emoji, text, expiration)
        presence && Slack.set_presence(token, presence)
        duration && Progress.start(duration * @miliseconds_in_minutes)
        duration && Slack.set_status(token)
        duration && presence && Slack.set_presence(token)
        duration && say && say_finished(say)

      duration ->
        IO.puts("Nothing to do")
    end
  end

  defp get_expiration(timezone, duration) do
    case duration do
      nil ->
        0

      _ ->
        Timex.now(timezone)
        |> Timex.shift(minutes: duration)
        |> Timex.to_unix()
    end
  end

  defp show_help do
    Enum.each(@help, fn line -> IO.puts(line) end)
  end

  defp say_finished(say) do
    System.cmd("say", [say])
  end
end

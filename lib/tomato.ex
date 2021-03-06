defmodule Tomato.CLI do
  alias Tomato.Config
  alias Tomato.Token
  alias Tomato.Params
  alias Tomato.Slack
  alias Tomato.Progress

  @config_file ".tomatoconfig"
  @miliseconds_in_minutes 1000 * 60
  @seconds_in_minutes 60
  @help [
    "",
    "Tomato v0.2.1",
    "Tool for set slack status and presence\n",
    "Usage: tomato [params]",
    "  -e - emoji: status emoji",
    "  -t - text: status text",
    "  -p - presence: auto | away",
    "  -d - duration: how long set status in minutes",
    "  -s - say: command say phrase at the end"
  ]

  def main(args \\ []) do
    config = get_config("#{System.user_home()}/#{@config_file}")

    args
    |> parse_args
    |> Params.init(config)
    |> process
  end

  defp get_config(file) do
    config = Config.init(file)
    token = config[:slack_token]
    new_token = Token.init(token)

    if token != new_token do
      Config.save("slack_token", new_token, file)
      get_config(file)
    else
      config
    end
  end

  defp parse_args(args) do
    {opts, _, _} =
      args
      |> OptionParser.parse(
        strict: [
          emoji: :string,
          text: :string,
          duration: :integer,
          presence: :string,
          say: :string
        ],
        aliases: [e: :emoji, t: :text, d: :duration, p: :presence, s: :say]
      )

    opts
  end

  defp process(params) do
    token = params[:slack_token]
    emoji = params[:emoji]
    text = params[:text]
    duration = params[:duration]
    presence = params[:presence]
    say = params[:say]

    cond do
      !token ->
        IO.puts("Token not set in config")

      emoji || text || presence ->
        expiration = get_expiration(duration)

        Slack.set_status(token, emoji, text, expiration)
        presence && Slack.set_presence(token, presence)
        duration && Progress.start(duration * @miliseconds_in_minutes, expiration)
        duration && Slack.set_status(token)
        duration && presence && Slack.set_presence(token)
        duration && say && say_finished(say)

      duration ->
        IO.puts("Nothing to do")

      true ->
        show_help()
    end
  end

  defp shift_time(time, duration) do
    time + duration
  end

  defp get_expiration(duration) do
    case duration do
      nil ->
        0

      _ ->
        DateTime.utc_now()
        |> DateTime.to_unix()
        |> shift_time(duration * @seconds_in_minutes)
    end
  end

  defp show_help do
    Enum.each(@help, fn line -> IO.puts(line) end)
  end

  defp say_finished(say) do
    System.cmd("say", [say])
  end
end

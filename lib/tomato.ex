# ./tomato                            -> :json[emoji]: json[text] json[duration] json[presence]
# ./tomato -e smile                   -> :smile: json[text] json[duration] json[presence]
# ./tomato -e smile -t test           -> :smile: test json[duration] json[presence]
# ./tomato -e smile -t test -d 40     -> :smile: test 40 json[presence]
# ./tomato -e smile -t test -d 40 -p  -> :smile: test 40 true

defmodule Tomato.CLI do
  alias Tomato.Config
  alias Tomato.Slack
  alias Tomato.Progress

  def main(args \\ []) do
    args
    |> parse_args
    |> tomat
  end

  defp parse_args(args) do
    {opts, _, _} =
      args
      |> OptionParser.parse(
        strict: [emoji: :string, text: :string, duration: :integer, presence: :boolean],
        aliases: [e: :emoji, t: :text, d: :duration, p: :presence]
      )

    opts
  end

  defp tomat(opts) do
    # token = get_token()
    # default_duration = 40
    # emoji = get_emoji(opts[:emoji])
    # text = opts[:text]
    # until = get_time("+3", opts[:duration] || default_duration)
    # message = "#{text} #{until}"
    # presence = opts[:presence]
    # time = opts[:duration] || default_duration

    params = Config.init("./config.json")

    # Slack.set_status(token, emoji, message)
    # presence && Slack.set_presence(token, "away")

    # Progress.start(time)

    # Slack.set_status(token, "", "")
    # presence && Slack.set_presence(token, "auto")
  end

  defp get_time(timezone, duration) do
    Timex.now(timezone)
    |> Timex.shift(minutes: duration)
    |> Timex.format!("{h24}:{m}")
  end
end

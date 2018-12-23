# без токена -> сообщение нет токена в конфиге, ссылка на описание в gh
# без параметров -> сообщение помощь по ключам
# только время –> сообщение нечего устанавливать
# комбинации имоджи/текст/присутствие –> устанавливаем без ограничения по времени
# комбинации имоджи/текст/присутствие + время –> устанавливаем комбинации имоджи/текст/присутствие с ограничением по времени

defmodule Tomato.CLI do
  alias Tomato.Config
  alias Tomato.Slack
  alias Tomato.Progress

  @config_filename "./config.json"
  @default_sound "doom.wav"

  def main(args \\ []) do
    args
    |> parse_args
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

  defp process ([]) do
    IO.puts "help"
  end

  defp process(opts) do
    params = Config.init(opts, @config_filename)
    token = params[:token]
    emoji = params[:emoji]
    text = params[:text]
    presence = (params[:presence] == "auto" || params[:presence] == "away") && params[:presence] || false
    duration = params[:duration]

    IO.inspect params

    cond do
      !token ->
        IO.puts "please set token"

      ((emoji || text || presence) && duration) ->
        IO.puts "emoji|text|presence and duration"

        until = get_time(params[:timezone] || 0, duration)
        message = "#{text} #{until}"
        Slack.set_status(token, emoji, message)
        presence && Slack.set_presence(token, presence)

        Progress.start(duration)

        Slack.set_status(token, "", "")
        presence && Slack.set_presence(token, !presence)

      (emoji || text || presence) ->
        IO.puts "emoji|text|presence"

        Slack.set_status(token, emoji, text)
        presence && Slack.set_presence(token, presence)

      duration
      true ->
        IO.puts "nothing to do"
    end
  end

  defp get_time(timezone, duration) do
    Timex.now(timezone)
    |> Timex.shift(minutes: duration)
    |> Timex.format!("{h24}:{m}")
  end
end

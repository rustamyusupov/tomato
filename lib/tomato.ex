defmodule Tomato.CLI do
  def main(args \\ []) do
    args
    |> parse_args
    |> set_status
  end

  defp parse_args(args) do
    {opts, _, _} =
      args
      |> OptionParser.parse(
        strict: [icon: :string, description: :string, time: :integer],
        aliases: [i: :icon, d: :description, t: :time]
      )

    opts
  end

  defp get_icon(icon) do
    if icon, do: icon, else: ":tomato:"
  end

  defp get_description(description) do
    if description, do: " #{description}", else: " фигачу"
  end

  defp get_time(time) do
    if time, do: " до #{Integer.to_string(time)}", else: " до +40"
  end

  defp get_status_message(opts) do
    icon = opts[:icon]
    description = opts[:description]
    time = opts[:time]

    get_icon(icon) <> get_description(description) <> get_time(time)
  end

  defp start_progress(time) do
    interval = Kernel.trunc(time * 1000 / 100) # in seconds

    Enum.each 1..100, fn (i) ->
      ProgressBar.render(i, 100)
      :timer.sleep interval
    end
  end

  defp start_timer(opts) do
    time = opts[:time]

    if time, do: start_progress(time), else: start_progress(40)
  end

  defp set_status(opts) do # сделать перегрузку функции
    IO.puts get_status_message(opts)

    start_timer(opts)

    IO.puts "clear"
  end
end

defmodule Tomato.CLI do
  def main(args \\ []) do
    args
    |> parse_args
    |> tomat
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

  defp tomat(opts) do
    get_status_message(opts) |> set_status

    start_timer(opts[:time])

    "clear" |> set_status
  end

  defp set_status(message) do
    IO.puts(message)
  end

  defp get_status_message(opts) do
    Enum.join([
      get_icon(opts[:icon]),
      get_description(opts[:description]),
      get_time(opts[:time])
    ], " ")
  end

  defp start_timer(time) do
    if time, do: start_progress(time), else: start_progress(40)
  end

  defp get_icon(icon) do
    if icon, do: ":#{String.downcase(icon)}:", else: ":tomato:"
  end

  defp get_description(description) do
    "фигачу" <> if description, do: " #{description}"
  end

  defp get_time(time) do
    if time, do: Integer.to_string(time), else: "+40"
  end

  defp start_progress(time) do
    interval = Kernel.trunc(time * 1000 / 100) # in seconds

    Enum.each 1..100, fn (i) ->
      ProgressBar.render(i, 100)
      :timer.sleep interval
    end
  end
end

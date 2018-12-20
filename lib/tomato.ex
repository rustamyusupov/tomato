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
    duration = 40
    icon = ":#{opts[:icon] || "tomato"}:"
    description = opts[:description] || "освобожусь в"
    until = get_time("+3", opts[:time] || duration)
    time = opts[:time] || duration

    Enum.join([icon, description, until], " ")
    |> set_status

    start_timer(time)

    "clear" |> set_status
  end

  defp set_status(message) do
    IO.puts(message)
  end

  defp get_time(timezone, duration) do
    Timex.now(timezone)
    |> Timex.shift(minutes: duration)
    |> Timex.format!("{h24}:{m}")
  end

  defp start_timer(time) do
    interval = Kernel.trunc(time * 1000 / 100) # * 60

    Enum.each 1..100, fn (i) ->
      ProgressBar.render(i, 100)
      :timer.sleep interval
    end
  end
end

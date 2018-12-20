defmodule Tomato.CLI do
  alias Tomato.Status
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
    |> Status.set

    Progress.start(time)

    Status.set("clear")
  end

  defp get_time(timezone, duration) do
    Timex.now(timezone)
    |> Timex.shift(minutes: duration)
    |> Timex.format!("{h24}:{m}")
  end
end

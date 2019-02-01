defmodule Tomato.ProgressBar do
  @format [
    bar: "=",
    blank: " ",
    left: "|",
    right: "|",
    percent: true,
    suffix: false,
    bar_color: [],
    blank_color: [],
    width: :auto
  ]
  @min_bar_width 1
  @max_bar_width 100
  @fallback 80

  def render(current, total) do
    percent = (current / total * 100) |> round

    suffix = [
      formatted_percent(@format[:percent], percent),
      formatted_suffix(@format[:suffix], current, total),
      newline_if_complete(current, total)
    ]

    write(
      @format,
      {@format[:bar], @format[:bar_color], percent},
      {@format[:blank], @format[:blank_color]},
      suffix
    )
  end

  defp formatted_percent(false, _), do: ""

  defp formatted_percent(true, number) do
    number
    |> Integer.to_string()
    |> String.pad_leading(4)
    |> Kernel.<>("%")
  end

  defp formatted_suffix(:count, total, total), do: " (#{total})"
  defp formatted_suffix(:count, current, total), do: " (#{current}/#{total})"
  defp formatted_suffix(false, _, _), do: ""

  defp newline_if_complete(total, total), do: "\n"
  defp newline_if_complete(_, _), do: ""

  def write(format, {bar, bar_color}, suffix) do
    write(format, {bar, bar_color, 100}, {"", []}, suffix)
  end

  def write(format, {bar, bar_color, bar_percent}, {blank, blank_color}, suffix) do
    {bar_width, blank_width} = bar_and_blank_widths(format, suffix, bar_percent)

    full_bar = [
      bar |> repeat(bar_width) |> color(bar_color),
      blank |> repeat(blank_width) |> color(blank_color)
    ]

    IO.write(chardata(format, full_bar, suffix))
  end

  defp bar_and_blank_widths(format, suffix, bar_percent) do
    full_bar_width = full_bar_width(format, suffix)
    bar_width = (bar_percent / 100 * full_bar_width) |> round
    blank_width = full_bar_width - bar_width

    {bar_width, blank_width}
  end

  defp chardata(format, bar, suffix) do
    [
      ansi_prefix(),
      format[:left],
      bar,
      format[:right],
      suffix
    ]
  end

  defp full_bar_width(format, suffix) do
    other_text = chardata(format, "", suffix) |> IO.chardata_to_string()
    determine(format[:width], other_text)
  end

  defp repeat("", _), do: ""

  defp repeat(bar, width) do
    bar
    |> String.graphemes()
    |> Stream.cycle()
    |> Enum.take(width)
    |> Enum.join()
  end

  def ansi_prefix do
    [
      ansi_clear_line(),
      "\r"
    ]
    |> Enum.join()
  end

  def strip_invisibles(string) do
    string |> String.replace(~r/\e\[\d*[a-zA-Z]|[\r\n]/, "")
  end

  def color(content, []), do: content

  def color(content, ansi_codes) do
    [ansi_codes, content, IO.ANSI.reset()]
  end

  defp ansi_clear_line do
    "\e[2K"
  end

  def determine(terminal_width_config, other_text) do
    available_width = terminal_width(terminal_width_config)
    other_width = other_text |> strip_invisibles() |> String.length()
    remaining_width = available_width - other_width

    clamp(remaining_width, @min_bar_width, @max_bar_width)
  end

  defp terminal_width(config) do
    case config do
      :auto -> terminaldetermine()
      fixed_value -> fixed_value
    end
  end

  defp clamp(number, min_value, max_value) do
    number |> min(max_value) |> max(min_value)
  end

  def terminaldetermine do
    case :io.columns() do
      {:ok, count} -> count
      _ -> @fallback
    end
  end
end

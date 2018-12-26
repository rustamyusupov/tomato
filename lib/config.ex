defmodule Tomato.Config do
  def init(file) do
    file
    |> get_options
  end

  def save(key, value, file) do
    file
    |> init
    |> get_data(key, value)
    |> write(file)
  end

  defp get_options(file) do
    case File.exists?(file) do
      true ->
        file
        |> read

      false ->
        []
    end
  end

  defp read(file) do
    File.read!(file)
    |> String.split(~r/\n|\r\n|\r/, trim: true)
    |> Enum.reject(fn line -> String.starts_with?(line, ["#", ";"]) end)
    |> Enum.map(fn line ->
      case String.split(line, ~r/\s/, parts: 2) do
        [option] -> {to_atom(option), true}
        [option, value] -> {to_atom(option), value}
      end
    end)
  end

  defp to_atom(option), do: String.downcase(option) |> String.to_atom()

  defp get_data(config, key, value) do
    if Enum.empty?(config) do
      "#{key} #{value}\n"
    else
      Enum.map(config, fn {c_key, c_value} ->
        if to_string(c_key) == key, do: "#{c_key} #{value}\n", else: "#{c_key} #{c_value}\n"
      end)
    end
  end

  defp write(data, file) do
    case File.write(file, data) do
      :ok ->
        file

      {:error, error} ->
        IO.puts("There was an error: #{error}")
        System.halt(0)
    end
  end
end

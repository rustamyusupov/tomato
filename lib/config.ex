defmodule Tomato.Config do
  def init(options, filename) do
    filename
    |> get_json
    |> convert
    |> get_params(convert(options))
  end

  defp get_json(filename) do
    with {:ok, body} <- File.read(filename),
         {:ok, json} <- Poison.decode(body), do: json
  end

  defp convert(json) do
    Enum.map(json, fn ({key, value}) -> {:"#{key}", value} end)
  end

  defp get_params(json_params, options) do
    json_params
    |> remove_empty_params()
    |> merge_params(options)
  end

  defp remove_empty_params(json_params) do
    Enum.reject(json_params, fn {_k, value} -> is_nil(value) end)
  end

  defp merge_params(json_params, options) do
    Keyword.merge(json_params, options)
  end
end

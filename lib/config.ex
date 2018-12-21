defmodule Tomato.Config do
  def init(filename) do
    filename
    |> get_json
    |> convert_json
    |> get_defaults
  end

  defp get_json(filename) do
    with {:ok, body} <- File.read(filename),
         {:ok, json} <- Poison.decode(body), do: json
  end

  defp convert_json(json) do
    Enum.map(json, fn ({key, value}) -> {:"#{key}", value} end)
  end

  defp get_defaults(json_params) do
    defaults = Application.get_all_env(:tomato)

    json_params
    |> remove_empty_params()
    |> merge_params(defaults)
  end

  defp remove_empty_params(json_params) do
    Enum.reject(json_params, fn {_k, value} -> is_nil(value) end)
  end

  defp merge_params(json_params, defaults) do
    Keyword.merge(defaults, json_params)
  end

  defp get_emoji(str) do
    if str != "", do: ":#{str}:", else: ""
  end
end

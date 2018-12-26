defmodule Tomato.Params do
  def init(options \\ [], config) do
    options
    |> convert_to_list
    |> get_params(config)
  end

  defp convert_to_list(params) do
    Enum.map(params, fn {key, value} -> {:"#{key}", value} end)
  end

  defp get_params(params, config) do
    params
    |> remove_empty_params()
    |> merge_params(config)
  end

  defp remove_empty_params(params) do
    Enum.reject(params, fn {_k, value} -> is_nil(value) end)
  end

  defp merge_params(params, config) do
    Keyword.merge(params, config)
  end
end

defmodule Tomato.Config do
  def init(options) do
    options
    |> convert_to_list
    |> get_params(get_env())
  end

  defp convert_to_list(params) do
    Enum.map(params, fn {key, value} -> {:"#{key}", value} end)
  end

  defp get_env do
    [
      token: System.get_env("TOMATO_TOKEN"),
      timezone: System.get_env("TOMATO_TIMEZONE")
    ]
  end

  defp get_params(options, env) do
    options
    |> remove_empty_params()
    |> merge_params(env)
  end

  defp remove_empty_params(params) do
    Enum.reject(params, fn {_k, value} -> is_nil(value) end)
  end

  defp merge_params(params, options) do
    Keyword.merge(params, options)
  end
end

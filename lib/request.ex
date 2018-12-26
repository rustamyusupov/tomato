defmodule Tomato.Request do
  def post(url, body, headers) do
    case HTTPoison.post(url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body |> Poison.decode() |> get_request_response

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  defp get_request_response(response) do
    case response do
      {:ok, response} -> response
    end
  end
end

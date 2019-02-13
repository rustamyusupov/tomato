defmodule Tomato.Progress do
  alias Tomato.ProgressBar

  def start(time, expiration) do
    interval = Kernel.trunc(time / 100)

    Enum.each(1..99, fn i ->
      now =
        DateTime.utc_now()
        |> DateTime.to_unix()

      if now <= expiration do
        ProgressBar.render(i, 100)
        :timer.sleep(interval)
      end
    end)

    ProgressBar.render(100, 100)
  end
end

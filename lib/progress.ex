defmodule Tomato.Progress do
  alias Tomato.ProgressBar

  def start(time) do
    interval = Kernel.trunc(time / 100)

    Enum.each(1..100, fn i ->
      ProgressBar.render(i, 100)
      :timer.sleep(interval)
    end)
  end
end

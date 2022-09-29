defmodule Hangman.Runtime.Watchdog do
  def start(expiry_time) do
    spawn_link(fn -> watcher(expiry_time) end)
  end

  def ping(watcher) do
    send(watcher, :ping)
  end

  defp watcher(expiry_time) do
    receive do
      :ping ->
        watcher(expiry_time)
    after
      expiry_time ->
        Process.exit(self(), {:shutdown, :watchdog_triggered})
    end
  end
end

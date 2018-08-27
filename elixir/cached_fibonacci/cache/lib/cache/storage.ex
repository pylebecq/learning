defmodule Cache.Storage do
  @me __MODULE__

  def start_link() do
    Agent.start_link(fn -> %{} end, name: @me)
  end

  def store(n, value) do
    Agent.update(@me, fn map -> Map.put(map, n, value) end)
  end

  def get(n) do
    Agent.get(@me, fn map -> map[n] end)
  end
end

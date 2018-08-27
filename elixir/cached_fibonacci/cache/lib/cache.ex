defmodule Cache do
  alias Cache.Storage

  @me __MODULE__

  defdelegate store(n, value), to: Storage
  defdelegate get(n), to: Storage
end

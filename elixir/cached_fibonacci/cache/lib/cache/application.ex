defmodule Cache.Application do
  use Application

  def start(_type, _args) do
    Cache.Storage.start_link()
  end
end

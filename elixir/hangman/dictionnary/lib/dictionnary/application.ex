defmodule Dictionnary.Application do
  use Application

  def start(_type, _args) do
    children = [
      Dictionnary.WordList
    ]
    options = [
      name: Dictionnary.Supervisor,
      strategy: :one_for_one
    ]

    Supervisor.start_link(children, options)
  end
end

defmodule Hangman.Runtime.Application do
  use Application

  def start(_type, _args) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: Hangman.Runtime.GameService}
    ]

    options = [
      strategy: :one_for_one
    ]

    Supervisor.start_link(children, options)
  end
end

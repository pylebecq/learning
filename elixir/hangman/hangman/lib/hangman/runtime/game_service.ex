defmodule Hangman.Runtime.GameService do
  def new_game do
    DynamicSupervisor.start_child(__MODULE__, {Hangman.Runtime.GameServer, nil})
  end
end

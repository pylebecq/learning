defmodule Hangman.Runtime.GameServer do
  alias Hangman.Impl.Game

  use GenServer

  @type t :: pid

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    state = Game.new_game()

    {:ok, state}
  end

  def handle_call({:make_move, guess}, _from, state) do
    {new_state, tally} = Game.make_move(state, guess)

    {:reply, tally, new_state}
  end

  def handle_call({:tally}, _from, state) do
    {:reply, Game.tally(state), state}
  end
end

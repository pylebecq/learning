defmodule Hangman.Runtime.GameServer do
  alias Hangman.Impl.Game

  use GenServer, restart: :transient

  @type t :: pid

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  @spec make_move(t, String.t()) :: Hangman.Type.tally()
  def make_move(pid, guess), do: GenServer.call(pid, {:make_move, guess})

  @spec tally(t) :: Hangman.Type.tally()
  def tally(pid), do: GenServer.call(pid, {:tally})

  def init(_) do
    state = Game.new_game()

    {:ok, state}
  end

  def handle_call({:make_move, guess}, _from, state) do
    Game.make_move(state, guess)
    |> maybe_stop()
  end

  def handle_call({:tally}, _from, state) do
    {:reply, Game.tally(state), state}
  end

  defp maybe_stop({state = %{game_state: game_state}, tally}) when game_state in [:won, :lost] do
    {:stop, :normal, tally, state}
  end

  defp maybe_stop({state, tally}), do: {:reply, tally, state}
end

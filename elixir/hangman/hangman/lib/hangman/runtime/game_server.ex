defmodule Hangman.Runtime.GameServer do
  alias Hangman.Impl.Game
  alias Hangman.Runtime.Watchdog

  use GenServer, restart: :transient

  @type t :: pid

  # 1 hour
  @idle_timeout 1 * 60 * 60 * 1000

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  @spec make_move(t, String.t()) :: Hangman.Type.tally()
  def make_move(pid, guess), do: GenServer.call(pid, {:make_move, guess})

  @spec tally(t) :: Hangman.Type.tally()
  def tally(pid), do: GenServer.call(pid, {:tally})

  def init(_) do
    watcher = Watchdog.start(@idle_timeout)
    state = Game.new_game()

    {:ok, {state, watcher}}
  end

  def handle_call({:make_move, guess}, _from, {game, watcher}) do
    Watchdog.ping(watcher)
    {updated_game, tally} = Game.make_move(game, guess)

    {:reply, tally, {updated_game, watcher}}
  end

  def handle_call({:tally}, _from, {game, watcher}) do
    Watchdog.ping(watcher)

    {:reply, Game.tally(game), {game, watcher}}
  end
end

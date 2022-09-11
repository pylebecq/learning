defmodule Hangman do
  alias Hangman.Runtime.GameService
  alias Hangman.Runtime.GameServer
  alias Hangman.Type

  @opaque game :: GameServer.t()
  @type tally :: Type.tally()

  @spec new_game() :: game
  def new_game do
    {:ok, pid} = GameService.new_game()

    pid
  end

  @spec make_move(game, String.t()) :: tally
  def make_move(game, guess), do: GameServer.make_move(game, guess)

  @spec tally(game) :: tally
  def tally(game), do: GameServer.tally(game)
end

defmodule Hangman.Game do

  defstruct [
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new(),
  ]

  def new_game() do
    %Hangman.Game{
      letters: Dictionnary.random_word |> String.codepoints
    }
  end

  def make_move(game = %{ game_state: state }, _) when state in [:won, :lost] do
    { game, tally(game) }
  end

  def make_move(game, guess) do
    game = accept_move(game, guess, MapSet.member?(game.used, guess))
    { game, tally(game) }
  end

  defp accept_move(game, _guess, _already_guessed = true) do
    struct(game, game_state: :already_used)
  end

  defp accept_move(game, guess, _already_guessed = false) do
    struct(game, used: MapSet.put(game.used, guess))
  end

  def tally(game) do
    123
  end

end

defmodule Hangman.Game do
  defstruct turns_left: 7,
            game_state: :initializing,
            letters: [],
            used: MapSet.new()

  def new_game() do
    new_game(Dictionnary.random_word())
  end

  def new_game(word) do
    %Hangman.Game{
      letters: word |> String.codepoints()
    }
  end

  def make_move(game = %{game_state: state}, _) when state in [:won, :lost] do
    game
  end

  def make_move(game, guess) do
    make_move(game, guess, guess =~ ~r/^[a-z]$/)
  end

  def tally(game) do
    %{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters: game.letters |> reveal_guessed(game.used)
    }
  end

  defp make_move(game, guess, _valid_guess = true) do
    accept_move(game, guess, MapSet.member?(game.used, guess))
  end

  defp make_move(game, _, _invalid_guess) do
    struct(game, game_state: :invalid_guess)
  end

  defp accept_move(game, _guess, _already_guessed = true) do
    struct(game, game_state: :already_used)
  end

  defp accept_move(game, guess, _not_already_guessed) do
    struct(game, used: MapSet.put(game.used, guess))
    |> score_guess(Enum.member?(game.letters, guess))
  end

  defp score_guess(game, _good_guess = true) do
    new_state =
      MapSet.new(game.letters)
      |> MapSet.subset?(game.used)
      |> maybe_won()

    struct(game, game_state: new_state)
  end

  defp score_guess(game = %{turns_left: 1}, _not_good_guess) do
    struct(game, game_state: :lost, turns_left: 0)
  end

  defp score_guess(game = %{turns_left: turns_left}, _not_good_guess) do
    struct(game, game_state: :bad_guess, turns_left: turns_left - 1)
  end

  defp maybe_won(true), do: :won
  defp maybe_won(_), do: :good_guess

  defp reveal_guessed(letters, used) do
    letters
    |> Enum.map(fn letter -> (MapSet.member?(used, letter) && letter) || "_" end)
  end
end

defmodule Hangman.Impl.Game do
  alias Hangman.Type

  @type t :: %__MODULE__{
          turns_left: integer,
          game_state: Type.state(),
          letters: list(String.t()),
          letters_used: MapSet.t(String.t())
        }

  defstruct turns_left: 7, game_state: :initializing, letters: [], letters_used: MapSet.new()

  @spec new_game :: t
  def new_game do
    Dictionary.random_word() |> new_game()
  end

  @spec new_game(String.t()) :: t
  def new_game(word) do
    %__MODULE__{
      letters: word |> String.graphemes()
    }
  end

  @spec make_move(t, String.t()) :: {t, Type.tally()}
  def make_move(game = %{game_state: state}, _guess) when state in [:won, :lost] do
    game |> return_with_tally()
  end

  def make_move(game, guess) do
    guess
    |> valid_guess?()
    |> accept_guess(game, guess, MapSet.member?(game.letters_used, guess))
    |> return_with_tally()
  end

  defp valid_guess?(guess), do: guess =~ ~r/^[a-z]$/

  defp accept_guess(_valid_guess = false, game, _guess, _already_used_guess) do
    game
  end

  defp accept_guess(_valid_guess = true, game, _guess, _already_used_guess = true) do
    %{game | game_state: :already_used}
  end

  defp accept_guess(_valid_guess = true, game, guess, _already_used_guess = false) do
    %{game | letters_used: MapSet.put(game.letters_used, guess)}
    |> score_guess(Enum.member?(game.letters, guess))
  end

  defp score_guess(game, _good_guess = true) do
    new_state = maybe_won(MapSet.subset?(MapSet.new(game.letters), game.letters_used))
    %{game | game_state: new_state}
  end

  defp score_guess(game = %{turns_left: 1}, _good_guess = false) do
    %{game | game_state: :lost, turns_left: 0}
  end

  defp score_guess(%{turns_left: turns_left} = game, _good_guess = false) do
    %{game | game_state: :bad_guess, turns_left: turns_left - 1}
  end

  defp return_with_tally(game) do
    {game, tally(game)}
  end

  @spec tally(t) :: Type.tally()
  def tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: reveal_guessed_letters(game),
      letters_used: game.letters_used |> MapSet.to_list() |> Enum.sort()
    }
  end

  defp reveal_guessed_letters(game = %{game_state: :lost}), do: game.letters

  defp reveal_guessed_letters(game) do
    game.letters
    |> Enum.map(fn letter ->
      letter_used?(game, letter) |> maybe_reveal(letter)
    end)
  end

  defp letter_used?(game, letter), do: MapSet.member?(game.letters_used, letter)

  defp maybe_reveal(true, letter), do: letter
  defp maybe_reveal(false, _letter), do: "_"

  defp maybe_won(_won = true) do
    :won
  end

  defp maybe_won(_won = false) do
    :good_guess
  end
end

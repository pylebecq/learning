defmodule HangmanGameTest do
  use ExUnit.Case
  doctest Hangman.Game

  alias Hangman.Game

  test "new_game returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
    assert Enum.all?(game.letters, fn x -> x =~ ~r/^[a-z]$/ end)
  end

  test "state isn't changed for :won or :lost game" do
    for state <- [:won, :lost] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert ^game = Game.make_move(game, "x")
    end
  end

  test "first occurrence of letter is not already used" do
    game = Game.new_game()
    game = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occurrence of letter is already used" do
    game = Game.new_game()
    game = Game.make_move(game, "x")
    assert game.game_state != :already_used
    game = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("wibble")
    game = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a guessed word is a won guess" do
    assert_moves(Game.new_game("wibble"), [
      {"w", :good_guess, 7},
      {"i", :good_guess, 7},
      {"b", :good_guess, 7},
      {"l", :good_guess, 7},
      {"e", :won, 7}
    ])
  end

  test "bad guess is recognized" do
    game = Game.new_game("wibble")
    game = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "7 bad guesses is a lost game" do
    assert_moves(Game.new_game("w"), [
      {"a", :bad_guess, 6},
      {"b", :bad_guess, 5},
      {"c", :bad_guess, 4},
      {"d", :bad_guess, 3},
      {"e", :bad_guess, 2},
      {"f", :bad_guess, 1},
      {"g", :lost, 0}
    ])
  end

  test "invalid move is recognized and do not reduce turns left" do
    assert_moves(Game.new_game("wibbles"), [
      {"A", :invalid_guess, 7},
      {":", :invalid_guess, 7},
      {"ab", :invalid_guess, 7}
    ])
  end

  defp assert_moves(game, moves) do
    Enum.reduce(moves, game, fn {guess, state, turns_left}, game ->
      game = Game.make_move(game, guess)
      assert game.game_state == state
      assert game.turns_left == turns_left
      game
    end)
  end
end

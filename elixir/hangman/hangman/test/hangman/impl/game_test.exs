defmodule Hangman.Impl.GameTest do
  use ExUnit.Case
  alias Hangman.Impl.Game
  doctest Hangman.Impl.Game

  test "new_game/0 returns a struct" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "new_game/1 returns a struct with the correct word" do
    game = Game.new_game("wombat")

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters == ["w", "o", "m", "b", "a", "t"]
  end

  test "make_move/2 does not change the state of the game if the game is already won or lost" do
    for state <- [:won, :lost] do
      game = Game.new_game("wombat") |> Map.put(:game_state, state)

      {new_state, _} = Game.make_move(game, "x")

      assert new_state == game
    end
  end

  test "a duplicate letter is reported" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state !== :already_used
    {game, _tally} = Game.make_move(game, "y")
    assert game.game_state !== :already_used
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state === :already_used
  end

  test "used letters are recorded" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    {game, _tally} = Game.make_move(game, "y")
    {game, _tally} = Game.make_move(game, "x")

    assert MapSet.equal?(game.letters_used, MapSet.new(["x", "y"])) == true
  end

  test "a good guess is properly recognized" do
    game = Game.new_game("wombat")

    {game, tally} = Game.make_move(game, "m")
    assert tally.game_state === :good_guess

    {_game, tally} = Game.make_move(game, "t")
    assert tally.game_state === :good_guess
  end

  test "a bad guess is properly recognized" do
    game = Game.new_game("wombat")

    {_game, tally} = Game.make_move(game, "x")
    assert tally.game_state === :bad_guess

    {_game, tally} = Game.make_move(game, "t")
    assert tally.game_state === :good_guess

    {_game, tally} = Game.make_move(game, "z")
    assert tally.game_state === :bad_guess
  end

  test "a sequence of moves is properly handled" do
    [
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["e", :good_guess, 6, ["_", "e", "_", "_", "_"], ["a", "e"]],
      ["x", :bad_guess, 5, ["_", "e", "_", "_", "_"], ["a", "e", "x"]]
    ]
    |> test_sequence_of_moves("hello")
  end

  test "a winning game is properly handled" do
    [
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["e", :good_guess, 6, ["_", "e", "_", "_", "_"], ["a", "e"]],
      ["x", :bad_guess, 5, ["_", "e", "_", "_", "_"], ["a", "e", "x"]],
      ["l", :good_guess, 5, ["_", "e", "l", "l", "_"], ["a", "e", "l", "x"]],
      ["o", :good_guess, 5, ["_", "e", "l", "l", "o"], ["a", "e", "l", "o", "x"]],
      ["y", :bad_guess, 4, ["_", "e", "l", "l", "o"], ["a", "e", "l", "o", "x", "y"]],
      ["h", :won, 4, ["h", "e", "l", "l", "o"], ["a", "e", "h", "l", "o", "x", "y"]]
    ]
    |> test_sequence_of_moves("hello")
  end

  test "a losing game is properly handled" do
    [
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["e", :good_guess, 6, ["_", "e", "_", "_", "_"], ["a", "e"]],
      ["x", :bad_guess, 5, ["_", "e", "_", "_", "_"], ["a", "e", "x"]],
      ["y", :bad_guess, 4, ["_", "e", "_", "_", "_"], ["a", "e", "x", "y"]],
      ["c", :bad_guess, 3, ["_", "e", "_", "_", "_"], ["a", "c", "e", "x", "y"]],
      ["f", :bad_guess, 2, ["_", "e", "_", "_", "_"], ["a", "c", "e", "f", "x", "y"]],
      [
        "j",
        :bad_guess,
        1,
        ["_", "e", "_", "_", "_"],
        ["a", "c", "e", "f", "j", "x", "y"]
      ],
      [
        "m",
        :lost,
        0,
        ["h", "e", "l", "l", "o"],
        ["a", "c", "e", "f", "j", "m", "x", "y"]
      ]
    ]
    |> test_sequence_of_moves("hello")
  end

  test "an invalid guess does not change the state of the game" do
    game = Game.new_game()

    {new_game, _tally} = Game.make_move(game, "A")
    assert new_game === game

    {new_game, _tally} = Game.make_move(game, "zx")
    assert new_game === game
  end

  defp test_sequence_of_moves(moves, word_to_guess) do
    game = Game.new_game(word_to_guess)

    Enum.reduce(moves, game, fn [guess, expected_state, turns_left, letters, letters_used],
                                game ->
      {game, tally} = Game.make_move(game, guess)
      assert tally.game_state === expected_state
      assert tally.turns_left === turns_left
      assert tally.letters === letters
      assert tally.letters_used === letters_used

      game
    end)
  end
end

defmodule Cli.Interact do
  alias Cli.{Player, State}

  def start() do
    Hangman.new_game()
    |> setup_state()
    |> Player.play()
  end

  def play(state) do
    # interactions
    play(state)
  end

  defp setup_state(game) do
    %State{
      game_service: game,
      tally: Hangman.tally(game)
    }
  end
end

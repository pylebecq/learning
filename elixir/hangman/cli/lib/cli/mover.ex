defmodule Cli.Mover do
  
  alias Cli.State

  def move(game) do
    {gs, tally} = Hangman.make_move(game.game_service, game.guess)
    %State{game | game_service: gs, tally: tally}
  end

end

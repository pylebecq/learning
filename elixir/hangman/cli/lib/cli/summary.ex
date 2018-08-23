defmodule Cli.Summary do
  def display(game = %{tally: tally}) do
    IO.puts([
      "\n",
      "Word so far: #{Enum.join(tally.letters, " ")}\n",
      "Guesses left: #{tally.turns_left}\n",
      "Letters already used: #{Enum.join(tally.used_letters, " ")}"
    ])

    game
  end
end

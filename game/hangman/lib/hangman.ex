defmodule Hangman do
  def hello do
    IO.puts Dictionnary.random_word()
  end
end

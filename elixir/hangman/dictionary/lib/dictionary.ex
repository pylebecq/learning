defmodule Dictionary do
  @word_list "assets/words.txt"
             |> File.read!()
             |> String.split("\n", trim: true)

  @spec random_word :: binary
  def random_word do
    @word_list
    |> Enum.random()
  end
end

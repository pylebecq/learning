defmodule Dictionary.Impl.WordList do
  @type t :: %__MODULE__{
          words: list(String.t())
        }

  defstruct words: []

  @spec word_list() :: t
  def word_list do
    words =
      "assets/words.txt"
      |> File.read!()
      |> String.split("\n", trim: true)

    %__MODULE__{words: words}
  end

  @spec random_word(t) :: String.t()
  def random_word(word_list) do
    word_list.words
    |> Enum.random()
  end
end

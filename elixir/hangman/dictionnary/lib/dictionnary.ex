defmodule Dictionnary do
  alias Dictionnary.WordList

  defdelegate start(), to: WordList, as: :word_list
  defdelegate random_word(words), to: WordList
end

defmodule Dictionnary do
  alias Dictionnary.WordList

  defdelegate random_word(), to: WordList
end

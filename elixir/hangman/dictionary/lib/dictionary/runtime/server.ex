defmodule Dictionary.Runtime.Server do
  alias Dictionary.Impl.WordList

  use Agent

  @type t :: pid

  @name __MODULE__

  def start_link(_) do
    Agent.start_link(&WordList.word_list/0, name: @name)
  end

  def random_word() do
    Agent.get(@name, &WordList.random_word/1)
  end
end

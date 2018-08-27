defmodule Dictionnary.Application do
  use Application

  def start(_type, _args) do
    Dictionnary.WordList.start_link()
  end
end

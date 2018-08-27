defmodule Dictionnary.WordList do
  @me __MODULE__

  def child_spec(_opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    }
  end

  def start_link() do
    Agent.start_link(&word_list/0, name: @me)
  end

  defp word_list() do
    "../../assets/words.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split(~r/\n/)
  end

  def random_word() do
    if :rand.uniform() < 0.33 do
      Agent.get(@me, fn _ -> exit(:boom) end)
    end
    Agent.get(@me, &Enum.random/1)
  end
end

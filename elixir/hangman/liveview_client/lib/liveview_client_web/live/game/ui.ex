defmodule LiveviewClientWeb.Live.Game.UI do
  use LiveviewClientWeb, :component

  @states %{
    already_used: "You already picked that letter",
    bad_guess: "That's not in the word",
    good_guess: "Good guess!",
    initializing: "Type or click on your first guess",
    lost: "Sorry, you lost 😩",
    won: "You won! 🎉"
  }

  # attr :tally, :map, required: true

  defdelegate figure(assigns), to: LiveviewClientWeb.Live.Game.Figure, as: :render

  attr :tally, :map, required: true

  def word_so_far(assigns) do
    ~H"""
    <div>
      <div>
        <%= word_so_far_state_name(@tally.game_state) %>
      </div>
      <div class="text-3xl tracking-widest">
        <%= for letter <- @tally.letters do %>
          <span class={if letter !== "_", do: "text-green-500", else: "text-cyan-700"}><%= letter %></span>
        <% end %>
      </div>
    </div>
    """
  end

  attr :tally, :map, required: true

  def alphabet(assigns) do
    ~H"""
    <div class="text-xl">
      <%= for letter <- (?a..?z |> Enum.map(&<<&1::utf8>>)) do %>
        <span phx-click="make_move" phx-value-key={letter} class={"cursor-pointer #{alphabet_class_of(letter, @tally)}"}><%= letter %></span>
      <% end %>
    </div>
    """
  end

  defp word_so_far_state_name(state) do
    @states[state] || "Unknown state"
  end

  defp alphabet_class_of(letter, tally) do
    cond do
      Enum.member?(tally.letters, letter) ->
        "text-green-500"

      Enum.member?(tally.letters_used, letter) ->
        "text-red-500"

      true ->
        "text-cyan-700"
    end
  end
end

defmodule LiveviewClientWeb.Live.Game do
  use LiveviewClientWeb, :live_view

  alias LiveviewClientWeb.Live.Game.UI
  alias LiveviewClientWeb.Live.Game.Figure

  def mount(_params, _session, socket) do
    game = Hangman.new_game()
    tally = Hangman.tally(game)

    socket =
      socket
      |> assign(%{
        game: game,
        tally: tally
      })

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div phx-window-keyup="make_move">
      <div class="flex flex-col items-center justify-items-center gap-y-8 mt-6">
      <Figure.render class="overflow-hidden w-full h-96 transition-opacity transition-duration-500" turns_left={@tally.turns_left} />
      <UI.alphabet tally={@tally} />
      <UI.word_so_far tally={@tally} />
      </div>
    </div>
    """
  end

  def handle_event("make_move", %{"key" => key}, socket) do
    tally = Hangman.make_move(socket.assigns.game, key)

    {:noreply, assign(socket, :tally, tally)}
  end
end

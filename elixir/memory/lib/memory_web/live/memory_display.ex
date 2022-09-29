defmodule MemoryWeb.Live.MemoryDisplay do
  use MemoryWeb, :live_view

  def mount(_params, _session, socket) do
    socket = schedule_tick_and_update_assigns(socket)

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
      <table>
        <%= for {name, value} <- assigns.memory do %>
          <tr>
            <th><%= name %></th>
            <td><%= value %></td>
          </tr>
        <% end %>
      </table>
    """
  end

  def handle_info(:tick, socket) do
    socket = schedule_tick_and_update_assigns(socket)

    {:noreply, socket}
  end

  defp schedule_tick_and_update_assigns(socket) do
    Process.send_after(self(), :tick, 1_000)

    assign(socket, :memory, :erlang.memory())
  end
end

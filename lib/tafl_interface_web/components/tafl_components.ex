defmodule TaflInterfaceWeb.Components.TaflComponents do
  use Phoenix.Component
  import TaflInterfaceWeb.CoreComponents

  def gamelist(assigns) do
    ~H"""
    <.button phx-click="create_game">
      Create New Game
    </.button>
    <div class="py-7">
      Open games:
    </div>

    <ul :for={name <- @list}>
      <li class="flex py-3">
        <%= name %>
        <%= if name != @player do %>
          <button class="px-3 leading-4 rounded-full " phx-click="join_game" phx-value-name={name}>
            <span class="inline-flex items-center px-2 py-1 text-xs font-medium text-yellow-700 rounded-md bg-yellow-50 ring-1 ring-inset ring-yellow-600/20">
              JOIN
            </span>
          </button>
        <% else %>
          <button class="px-3 leading-4 rounded-full ">
            <span class="inline-flex items-center px-2 py-1 text-xs font-medium text-yellow-700 rounded-md bg-yellow-50 ring-1 ring-inset ring-yellow-600/20">
              ...
            </span>
          </button>
        <% end %>
      </li>
    </ul>
    """
  end

  def register(assigns) do
    ~H"""
    <div id="something" class="grid gap-6 mb-6 md:grid-cols-2">
      <form phx-submit="register">
        <input
          type="text"
          label="player"
          name="player"
          value={@player}
          placeholder="Player's Name"
          autocomplete="off"
          class="block w-full"
        />
      </form>
    </div>
    """
  end

  def board(assigns) do
    ~H"""
    <div>
      <span>
        You are playing as
      </span>
      <button>
        Switch players
      </button>
      <%= inspect(@game) %>
    </div>
    """
  end
end

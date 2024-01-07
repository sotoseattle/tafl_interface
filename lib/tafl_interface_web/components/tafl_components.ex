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
        <%= if @turn do %>
          It is my turn! <%= @player %>
        <% else %>
          Wait, it is the other player's turn
        <% end %>
      </span>

      <%= if @game do %>
        <%= if @game.rules.state in [:initialized, :players_set] do %>
          <.button phx-click="flip_players">
            Switch players
          </.button>
          <.button phx-click="start_the_game">
            Start
          </.button>
        <% end %>
      <% end %>

      <div class="grid grid-cols-9 gap-1 py-20">
        <%= for x <- 1..9, y <- 1..9 do %>
          <% [color, type] = moco(@game.board, x, y) %>
          <div class={"h-16 py-5 text-xl text-center border-2 #{color}"}>
            <%= type %>
          </div>
        <% end %>
      </div>

      <hl />
      <%= inspect(@game, pretty: true) %>
    </div>
    """
  end

  def moco(%{%TaflEngine.Cell{row: x, col: y} => v}, x, y) do
    case v do
      %TaflEngine.Piece{type: :pawn, color: :hunters} -> ["bg-purple-100", "(*_*)"]
      %TaflEngine.Piece{type: :pawn} -> ["bg-yellow-200", "ಠ_ಠ"]
      %TaflEngine.Piece{type: :king} -> ["bg-yellow-500", "ಠ_ಠ"]
    end
  end

  def moco(_, _, _) do
    ["", ""]
  end
end

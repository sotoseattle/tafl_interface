defmodule TaflInterfaceWeb.GameLive do
  use TaflInterfaceWeb, :live_view

  alias TaflInterfaceWeb.Components.TaflComponents
  alias TaflInterface.Game

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        player: nil,
        registered: false,
        games: Game.game_list(),
        game: %{}
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <pre>
    </pre>

    <%= if @registered do %>
      <%= if @game==%{} do %>
        <TaflComponents.gamelist list={@games} player={@player} />
      <% else %>
        <TaflComponents.board game={@game} player={@player} />
      <% end %>
    <% else %>
      <TaflComponents.register player={@player} />
    <% end %>

    <hr />
    """
  end

  def handle_event("register", %{"player" => player}, socket) do
    {:noreply,
     assign(socket,
       game: Game.find_game(player),
       player: player,
       registered: true
     )}
  end

  def handle_event("create_game", _params, socket) do
    socket.assigns.player
    |> Game.start_game()
    |> Game.subscribe()

    {:noreply, socket}
  end

  def handle_event("flip_players", _params, socket) do
    socket.assigns.game.owner
    |> Game.flip_players()
    |> Game.broadcast_update()

    {:noreply, socket}
  end

  def handle_event("join_game", %{"name" => game_owner}, socket) do
    game_owner
    |> Game.join_game(socket.assigns.player)
    |> Game.subscribe()

    {:noreply, socket}
  end

  def handle_event("start_the_game", _params, socket) do
    socket.assigns.game.owner
    |> Game.start_the_game()
    |> Game.broadcast_update()

    {:noreply, socket}
  end

  def handle_info({:update_state, new_state}, socket) do
    {:noreply, assign(socket, game: new_state)}
  end
end

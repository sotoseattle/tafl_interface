defmodule TaflInterfaceWeb.GameLive do
  use TaflInterfaceWeb, :live_view

  alias TaflInterfaceWeb.Components.TaflComponents
  alias TaflEngine.GameSupervisor
  alias TaflEngine.Game

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        player: nil,
        registered: false,
        games: refresh_game_list(),
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
        <TaflComponents.board gamelist={@games} player={@player} />
      <% end %>
    <% else %>
      <TaflComponents.register player={@player} />
    <% end %>

    <hr />
    """
  end

  def handle_event("register", %{"player" => player}, socket) do
    {:noreply, assign(socket, player: player, registered: true)}
  end

  def handle_event("create_game", _params, socket) do
    game_creator = socket.assigns.player

    {:ok, gpid} = GameSupervisor.start_game(game_creator)
    # game = Game.via_tuple(game_creator)
    gamestato = :sys.get_state(gpid)

    {:noreply, assign(socket, game: gamestato)}
  end

  def handle_event("join_game", %{"name" => x}, socket) do
    game_creator = x
    new_player = socket.assigns.player

    game = Game.via_tuple(game_creator)
    Game.add_new_player(game, new_player)

    gamestato =
      :sys.get_state(game)
      |> IO.inspect()

    {:noreply, assign(socket, game: gamestato)}
    # {:noreply, socket}
  end

  defp refresh_game_list() do
    GameSupervisor.list_open_games()
    |> Enum.map(fn x -> "#{x}" end)
  end
end

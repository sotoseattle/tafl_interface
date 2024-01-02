defmodule TaflInterfaceWeb.GameLive do
  use TaflInterfaceWeb, :live_view

  alias TaflInterfaceWeb.Components.TaflComponents
  alias TaflEngine.GameSupervisor
  # alias TaflEngine.Game

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        player: nil,
        registered: false,
        games: refresh_game_list()
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <pre>
    </pre>

    <%= if @registered do %>
      <TaflComponents.gamelist list={@games} />
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
    player = socket.assigns.player

    {:ok, gpid} = GameSupervisor.start_game(player)

    IO.inspect(gpid, label: "---------------------------------------")

    {:noreply, assign(socket, games: refresh_game_list())}
  end

  def handle_event("join_game", %{"name" => x}, socket) do
    IO.inspect(x, label: "_______^________")
    IO.inspect(socket.assigns.player, label: "_______^________")
    IO.inspect(self())
    # game = Game.via_tuple(owner)
    # Game.add_new_player(game, "whatever")

    # {:noreply, assign(socket, game: :sys.get_state(game))}
    {:noreply, socket}
  end

  defp refresh_game_list() do
    GameSupervisor.list_open_games()
    |> Enum.map(fn x -> "#{x}" end)
  end
end

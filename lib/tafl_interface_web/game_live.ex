defmodule TaflInterfaceWeb.GameLive do
  use TaflInterfaceWeb, :live_view

  alias TaflInterfaceWeb.Components.TaflComponents
  alias TaflInterface.Game

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        player: nil,
        my_turn: false,
        registered: false,
        games: Game.game_list(),
        game: %{},
        from: {nil, nil}
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
        <TaflComponents.board game={@game} player={@player} turn={@my_turn} from={@from} />
      <% end %>
    <% else %>
      <TaflComponents.register player={@player} />
    <% end %>

    <hr />
    """
  end

  def handle_event("register", %{"player" => player}, socket) do
    g = Game.find_game(player)

    if Map.has_key?(g, :owner) do
      Game.subscribe(g.owner)
    end

    {:noreply,
     assign(socket,
       game: g,
       player: player,
       registered: true
     )}
  end

  def handle_event("create_game", _params, socket) do
    socket.assigns.player
    |> Game.new_game()
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

  def handle_event("select", %{"row" => row, "col" => col} = params, socket) do
    # IO.puts("-------------------------------")
    # IO.inspect(params)
    # IO.puts("row: #{row}")
    # IO.puts("col: #{col}")
    # IO.puts("-------------------------------")

    socket = assign(socket, from: {row, col})

    {:noreply, socket}
  end

  def handle_info({:update_state, new_state}, socket) do
    p1 = socket.assigns.player
    p2 = Map.get(new_state, turn_of(new_state.rules.state))

    {:noreply, assign(socket, game: new_state, my_turn: p1 == p2)}
  end

  defp turn_of(state_turn) do
    "#{state_turn}" |> String.trim_trailing("_turn") |> String.to_atom()
  end
end

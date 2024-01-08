defmodule TaflInterface.Game do
  alias TaflEngine.Game
  alias TaflEngine.GameSupervisor

  def new_game(game_owner) do
    GameSupervisor.start_game(game_owner)
    game_owner
  end

  def find_game(player) do
    GameSupervisor.find_game(player) |> List.first() || %{}
  end

  def join_game(game_owner, new_player) do
    game_owner
    |> Game.via_tuple()
    |> Game.add_new_player(new_player)

    game_owner
  end

  def flip_players(game_owner) do
    game_owner
    |> Game.via_tuple()
    |> Game.change_sides()

    game_owner
  end

  def start_the_game(game_owner) do
    game_owner
    |> Game.via_tuple()
    |> Game.start_game()

    game_owner
  end

  def move(game_owner, player, from, to) do
    IO.puts("********* MOVING ********* #{player}")

    game_owner
    |> Game.via_tuple()
    |> Game.move_piece(player, to_int(from), to_int(to))
    |> IO.inspect()

    game_owner
  end

  def game_list() do
    GameSupervisor.list_open_games()
    |> Enum.map(fn x -> "#{x}" end)
  end

  def subscribe(game_owner) do
    Phoenix.PubSub.subscribe(TaflInterface.PubSub, game_owner)
    broadcast_update(game_owner)
  end

  def broadcast_update(game_owner) do
    gpid = Game.via_tuple(game_owner)

    Phoenix.PubSub.broadcast(
      TaflInterface.PubSub,
      game_owner,
      {:update_state, Game.get_state(gpid)}
    )
  end

  def to_int({x, y}) do
    {String.to_integer(x), String.to_integer(y)}
  end
end

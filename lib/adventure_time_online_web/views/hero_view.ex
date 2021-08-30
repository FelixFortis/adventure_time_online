defmodule AdventureTimeOnlineWeb.HeroView do
  use AdventureTimeOnlineWeb, :view

  alias AdventureTime.GameTile

  def header("new.html", _assigns) do
    ~e{Create a Hero!}
  end

  def header("game.html", assigns) do
    assigns.hero_name
  end

  def draw_tile(game_tile, hero_name) do
    cond do
      game_tile.walkable == false ->
        ~e{<td class="w-12 h-12 border-2 border-gray-900 bg-gray-700"></td>}

      GameTile.hero_count(game_tile.tile_ref) > 1 && GameTile.heroes_on_tile?(game_tile.tile_ref) &&
          GameTile.hero_on_tile?(game_tile.tile_ref, hero_name) ->
        ~e{<td class="w-12 h-12 border-2 border-gray-900 bg-yellow-500"></td>}

      GameTile.hero_count(game_tile.tile_ref) == 1 &&
          GameTile.hero_on_tile?(game_tile.tile_ref, hero_name) ->
        ~e{<td class="w-12 h-12 border-2 border-gray-900 bg-green-500"></td>}

      GameTile.heroes_on_tile?(game_tile.tile_ref) ->
        ~e{<td class="w-12 h-12 border-2 border-gray-900 bg-red-500"></td>}

      true ->
        ~e{<td class="w-12 h-12 border-2 border-gray-900"></td>}
    end
  end
end

defmodule AdventureTimeOnlineWeb.HeroLive do
  use AdventureTimeOnlineWeb, :live_view

  alias AdventureTime.{Arena, GameTile, HeroServer}
  alias AdventureTimeOnline.Heroes

  @impl true
  def mount(_params, %{"current_hero" => hero_name}, socket) do
    if connected?(socket), do: Heroes.subscribe()

    {:ok, assign(socket, :current_hero, hero_name)}
  end

  @impl true
  def mount(_params, _, socket) do
    {:ok, redirect(socket, to: "/")}
  end

  @impl true
  def handle_event("left", _, socket) do
    hero_name = socket.assigns.current_hero
    hero_current_tile_ref = HeroServer.tile_ref(hero_name)
    {y_axis, x_axis} = hero_current_tile_ref
    new_tile_ref = {y_axis, x_axis - 1}

    HeroServer.move_to(hero_name, new_tile_ref)
    {:noreply, socket}
  end

  defp draw_tile(game_tile, hero_name) do
    cond do
      game_tile.walkable == false ->
        ~e{<td class="w-12 h-12 border-2 border-gray-900 bg-gray-700"></td>}

      GameTile.hero_on_tile?(game_tile.tile_ref, hero_name) &&
          HeroServer.alive?(hero_name) == false ->
        ~e{<td class="w-12 h-12 border-2 border-gray-900 bg-indigo-500"></td>}

      GameTile.hero_count(game_tile.tile_ref) > 1 && GameTile.heroes_on_tile?(game_tile.tile_ref) &&
        GameTile.hero_on_tile?(game_tile.tile_ref, hero_name) &&
          GameTile.alive_enemies_on_tile?(game_tile.tile_ref, hero_name) ->
        ~e{<td class="w-12 h-12 border-2 border-gray-900 bg-yellow-500"></td>}

      GameTile.hero_on_tile?(game_tile.tile_ref, hero_name) ->
        ~e{<td class="w-12 h-12 border-2 border-gray-900 bg-green-500"></td>}

      GameTile.heroes_on_tile?(game_tile.tile_ref) &&
          GameTile.anyone_alive_on_tile?(game_tile.tile_ref) ->
        ~e{<td class="w-12 h-12 border-2 border-gray-900 bg-red-500"></td>}

      GameTile.heroes_on_tile?(game_tile.tile_ref) ->
        ~e{<td class="w-12 h-12 border-2 border-gray-900 bg-blue-500"></td>}

      true ->
        ~e{<td class="w-12 h-12 border-2 border-gray-900"></td>}
    end
  end
end

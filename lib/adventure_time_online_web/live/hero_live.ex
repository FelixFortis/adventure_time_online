defmodule AdventureTimeOnlineWeb.HeroLive do
  use AdventureTimeOnlineWeb, :live_view

  alias AdventureTime.{Arena, GameTile, HeroServer, HeroSupervisor}

  @impl true
  def mount(_params, %{"current_hero" => hero_name}, socket) do
    case HeroServer.hero_pid(hero_name) do
      pid when is_pid(pid) ->
        if connected?(socket), do: Phoenix.PubSub.subscribe(AdventureTimeOnline.PubSub, "heroes")

        heroes = HeroServer.all_heroes_as_map()
        current_hero = HeroServer.get_hero(hero_name)

        socket =
          assign(socket, current_hero_name: hero_name, current_hero: current_hero, heroes: heroes)

        {:ok, socket}

      nil ->
        {:ok, redirect(socket, to: "/")}
    end
  end

  @impl true
  def mount(_params, _, socket) do
    {:ok, redirect(socket, to: "/")}
  end

  @impl true
  def handle_event("respawn", _, socket) do
    case HeroServer.hero_pid(socket.assigns.current_hero_name) do
      pid when is_pid(pid) ->
        HeroServer.respawn(socket.assigns.current_hero_name)

        Phoenix.PubSub.broadcast(AdventureTimeOnline.PubSub, "heroes", :update)

      nil ->
        {:ok, redirect(socket, to: "/")}
    end
  end

  @impl true
  def handle_event("end", _, socket) do
    case HeroServer.hero_pid(socket.assigns.current_hero_name) do
      pid when is_pid(pid) ->
        HeroSupervisor.stop_hero(socket.assigns.current_hero_name)

        Phoenix.PubSub.broadcast(AdventureTimeOnline.PubSub, "heroes", :update)

        {:noreply, redirect(socket, to: "/")}

      nil ->
        {:ok, redirect(socket, to: "/")}
    end
  end

  @impl true
  def handle_event("left", _, socket) do
    case HeroServer.hero_pid(socket.assigns.current_hero_name) do
      pid when is_pid(pid) ->
        {y_axis, x_axis} = socket.assigns.current_hero.tile_ref
        new_tile_ref = {y_axis, x_axis - 1}

        HeroServer.move_to(socket.assigns.current_hero_name, new_tile_ref)

        Phoenix.PubSub.broadcast(AdventureTimeOnline.PubSub, "heroes", :update)

      nil ->
        {:ok, redirect(socket, to: "/")}
    end
  end

  @impl true
  def handle_event("right", _, socket) do
    case HeroServer.hero_pid(socket.assigns.current_hero_name) do
      pid when is_pid(pid) ->
        {y_axis, x_axis} = socket.assigns.current_hero.tile_ref
        new_tile_ref = {y_axis, x_axis + 1}

        HeroServer.move_to(socket.assigns.current_hero_name, new_tile_ref)

        Phoenix.PubSub.broadcast(AdventureTimeOnline.PubSub, "heroes", :update)

      nil ->
        {:ok, redirect(socket, to: "/")}
    end
  end

  @impl true
  def handle_event("up", _, socket) do
    case HeroServer.hero_pid(socket.assigns.current_hero_name) do
      pid when is_pid(pid) ->
        {y_axis, x_axis} = socket.assigns.current_hero.tile_ref
        new_tile_ref = {y_axis - 1, x_axis}

        HeroServer.move_to(socket.assigns.current_hero_name, new_tile_ref)

        Phoenix.PubSub.broadcast(AdventureTimeOnline.PubSub, "heroes", :update)

      nil ->
        {:ok, redirect(socket, to: "/")}
    end
  end

  @impl true
  def handle_event("down", _, socket) do
    case HeroServer.hero_pid(socket.assigns.current_hero_name) do
      pid when is_pid(pid) ->
        {y_axis, x_axis} = socket.assigns.current_hero.tile_ref
        new_tile_ref = {y_axis + 1, x_axis}

        HeroServer.move_to(socket.assigns.current_hero_name, new_tile_ref)

        Phoenix.PubSub.broadcast(AdventureTimeOnline.PubSub, "heroes", :update)

      nil ->
        {:ok, redirect(socket, to: "/")}
    end
  end

  @impl true
  def handle_event("attack", _, socket) do
    case HeroServer.hero_pid(socket.assigns.current_hero_name) do
      pid when is_pid(pid) ->
        HeroServer.attack(socket.assigns.current_hero_name)

        Phoenix.PubSub.broadcast(AdventureTimeOnline.PubSub, "heroes", :update)

      nil ->
        {:ok, redirect(socket, to: "/")}
    end
  end

  @impl true
  def handle_info(:update, socket) do
    heroes = HeroServer.all_heroes_as_map()
    {:noreply, assign(socket, :heroes, heroes)}
  end

  defp draw_tile(game_tile, hero) do
    cond do
      game_tile.walkable == false ->
        ~e{<td class="w-12 h-12 border-2 border-gray-900 bg-gray-700"></td>}

      GameTile.hero_on_tile?(game_tile.tile_ref, hero.name) &&
          HeroServer.alive?(hero.name) == false ->
        ~e{<td class="w-12 h-12 border-2 border-gray-900 bg-indigo-500"></td>}

      GameTile.hero_count(game_tile.tile_ref) > 1 && GameTile.heroes_on_tile?(game_tile.tile_ref) &&
        GameTile.hero_on_tile?(game_tile.tile_ref, hero.name) &&
          GameTile.alive_enemies_on_tile?(game_tile.tile_ref, hero.name) ->
        ~e{<td class="w-12 h-12 border-2 border-gray-900 bg-yellow-500"></td>}

      GameTile.hero_on_tile?(game_tile.tile_ref, hero.name) ->
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

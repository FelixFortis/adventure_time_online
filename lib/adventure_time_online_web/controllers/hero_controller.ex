defmodule AdventureTimeOnlineWeb.HeroController do
  use AdventureTimeOnlineWeb, :controller

  plug :require_hero when action in [:game]

  alias AdventureTime.{HeroServer, HeroSupervisor, Arena, GameTile, NameGenerator}

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"hero" => %{"hero_name" => name}}) do
    hero_name =
      case name do
        "" ->
          NameGenerator.generate()

        nil ->
          NameGenerator.generate()

        _ ->
          name
      end

    case HeroSupervisor.start_hero(hero_name) do
      {:ok, _hero_pid} ->
        conn
        |> put_session(:current_hero, hero_name)
        |> redirect(to: Routes.hero_path(conn, :game))

      {:error, _error} ->
        conn
        |> put_flash(:error, "Couldn't create hero")
        |> redirect(to: Routes.hero_path(conn, :new))
    end
  end

  def remove_hero(conn, _params) do
    hero_name = get_session(conn, :current_hero)

    case HeroSupervisor.stop_hero(hero_name) do
      :ok ->
        conn
        |> clear_session()
        |> redirect(to: Routes.hero_path(conn, :new))

      {:error, _error} ->
        conn
        |> put_flash(
          :error,
          "Couldn't find hero, try clearing your browser cache and refreshing the page"
        )
        |> clear_session()
        |> redirect(to: Routes.hero_path(conn, :new))
    end
  end

  def game(conn, _params) do
    arena = Arena.arena_as_list()
    hero_name = get_session(conn, :current_hero)

    case HeroServer.hero_pid(hero_name) do
      pid when is_pid(pid) ->
        conn
        |> assign(:hero_name, hero_name)
        |> render("game.html", arena: arena, hero_name: hero_name)

      nil ->
        conn
        |> put_flash(:error, "Hero not found!")
        |> redirect(to: Routes.hero_path(conn, :new))
    end
  end

  def move_left(conn, _params) do
    hero_name = get_session(conn, :current_hero)

    case HeroServer.hero_pid(hero_name) do
      pid when is_pid(pid) ->
        hero_current_tile_ref = HeroServer.tile_ref(hero_name)
        {y_axis, x_axis} = hero_current_tile_ref
        new_tile_ref = {y_axis, x_axis - 1}

        HeroServer.move_to(hero_name, new_tile_ref)

        conn
        |> redirect(to: Routes.hero_path(conn, :game))

      nil ->
        conn
        |> put_flash(:error, "Hero not found!")
        |> redirect(to: Routes.hero_path(conn, :new))
    end
  end

  def move_right(conn, _params) do
    hero_name = get_session(conn, :current_hero)

    case HeroServer.hero_pid(hero_name) do
      pid when is_pid(pid) ->
        hero_current_tile_ref = HeroServer.tile_ref(hero_name)
        {y_axis, x_axis} = hero_current_tile_ref
        new_tile_ref = {y_axis, x_axis + 1}

        HeroServer.move_to(hero_name, new_tile_ref)

        conn
        |> redirect(to: Routes.hero_path(conn, :game))

      nil ->
        conn
        |> put_flash(:error, "Hero not found!")
        |> redirect(to: Routes.hero_path(conn, :new))
    end
  end

  def move_up(conn, _params) do
    hero_name = get_session(conn, :current_hero)

    case HeroServer.hero_pid(hero_name) do
      pid when is_pid(pid) ->
        hero_current_tile_ref = HeroServer.tile_ref(hero_name)
        {y_axis, x_axis} = hero_current_tile_ref
        new_tile_ref = {y_axis - 1, x_axis}

        HeroServer.move_to(hero_name, new_tile_ref)

        conn
        |> redirect(to: Routes.hero_path(conn, :game))

      nil ->
        conn
        |> put_flash(:error, "Hero not found!")
        |> redirect(to: Routes.hero_path(conn, :new))
    end
  end

  def move_down(conn, _params) do
    hero_name = get_session(conn, :current_hero)

    case HeroServer.hero_pid(hero_name) do
      pid when is_pid(pid) ->
        hero_current_tile_ref = HeroServer.tile_ref(hero_name)
        {y_axis, x_axis} = hero_current_tile_ref
        new_tile_ref = {y_axis + 1, x_axis}

        HeroServer.move_to(hero_name, new_tile_ref)

        conn
        |> redirect(to: Routes.hero_path(conn, :game))

      nil ->
        conn
        |> put_flash(:error, "Hero not found!")
        |> redirect(to: Routes.hero_path(conn, :new))
    end
  end

  def attack(conn, _params) do
    hero_name = get_session(conn, :current_hero)

    case HeroServer.hero_pid(hero_name) do
      pid when is_pid(pid) ->
        HeroServer.attack(hero_name)

        conn
        |> redirect(to: Routes.hero_path(conn, :game))

      nil ->
        conn
        |> put_flash(:error, "Hero not found!")
        |> redirect(to: Routes.hero_path(conn, :new))
    end
  end

  defp require_hero(conn, _opts) do
    if get_session(conn, :current_hero) do
      conn
    else
      conn
      |> put_session(:return_to, conn.request_path)
      |> redirect(to: Routes.hero_path(conn, :new))
      |> halt()
    end
  end
end

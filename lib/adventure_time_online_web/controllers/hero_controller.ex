defmodule AdventureTimeOnlineWeb.HeroController do
  use AdventureTimeOnlineWeb, :controller

  plug :require_hero when action in [:game]

  alias AdventureTime.{HeroSupervisor, NameGenerator}

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

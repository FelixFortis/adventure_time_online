defmodule AdventureTimeOnlineWeb.HeroController do
  use AdventureTimeOnlineWeb, :controller

  plug :require_hero

  def new(conn, _params) do
    render(conn, "new.html")
  end

  defp require_hero(conn, _opts) do
    if get_session(conn, :current_hero) do
      conn
    else
      conn
      |> put_session(:return_to, conn.request_path)
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    end
  end
end

defmodule AdventureTimeOnlineWeb.SessionController do
  use AdventureTimeOnlineWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, _params) do
  end

  def delete(conn, _params) do
  end
end

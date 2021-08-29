defmodule AdventureTimeOnlineWeb.PageController do
  use AdventureTimeOnlineWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

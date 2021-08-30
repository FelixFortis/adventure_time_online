defmodule AdventureTimeOnlineWeb.PageControllerTest do
  use AdventureTimeOnlineWeb.ConnCase

  setup do
    Application.stop(:adventure_time)
    :ok = Application.start(:adventure_time)
  end

  describe "root path" do
    test "it redirects the user to the hero creation page", %{conn: conn} do
      conn = get(conn, "/")

      assert html_response(conn, 200) =~ "Create a Hero!"
    end
  end

  describe "new hero path" do
    test "the hero creation page is rendered", %{conn: conn} do
      conn = get(conn, Routes.hero_path(conn, :new))

      assert html_response(conn, 200) =~ "Create a Hero!"
    end
  end

  describe "create hero" do
    test "it creates a hero, adds them to the session and redirects the user to the game page",
         %{conn: conn} do
      conn = post(conn, Routes.hero_path(conn, :create), hero: %{"hero_name" => "test_hero"})

      assert Plug.Conn.get_session(conn, :current_hero) == "test_hero"
      assert redirected_to(conn) == Routes.hero_path(conn, :game)

      conn = get(conn, Routes.hero_path(conn, :game))

      assert html_response(conn, 200) =~ "test_hero"
      assert html_response(conn, 200) =~ "End Game"
    end
  end

  describe "end game" do
    test "it removes the hero from the session and redirects the user to the hero creation page",
         %{conn: conn} do
      conn = post(conn, Routes.hero_path(conn, :create), hero: %{"hero_name" => "test_hero"})
      conn = delete(conn, Routes.hero_path(conn, :remove_hero))

      assert Plug.Conn.get_session(conn, :current_hero) == nil
      assert redirected_to(conn) == Routes.hero_path(conn, :new)

      conn = get(conn, Routes.hero_path(conn, :new))

      assert html_response(conn, 200) =~ "Create a Hero!"
    end
  end
end

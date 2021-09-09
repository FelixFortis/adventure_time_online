defmodule AdventureTimeOnlineWeb.PageControllerTest do
  use AdventureTimeOnlineWeb.ConnCase
  alias AdventureTimeOnlineWeb.HeroLive

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
      hero = Plug.Conn.get_session(conn, :current_hero)

      assert hero.name == "test_hero"
      assert hero.tag == :test_hero
      assert redirected_to(conn) == Routes.live_path(conn, HeroLive)

      conn = get(conn, Routes.live_path(conn, HeroLive))

      assert html_response(conn, 200) =~ "test_hero"
      assert html_response(conn, 200) =~ "End Game"
    end
  end
end

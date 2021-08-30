defmodule AdventureTimeOnlineWeb.Router do
  use AdventureTimeOnlineWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AdventureTimeOnlineWeb do
    pipe_through :browser

    get "/", HeroController, :new

    resources "/heroes", HeroController, only: [:new, :create]

    delete "/heroes", HeroController, :remove_hero
    patch "heroes/respawn", HeroController, :respawn

    patch "/heroes/left", HeroController, :move_left
    patch "/heroes/right", HeroController, :move_right
    patch "/heroes/up", HeroController, :move_up
    patch "/heroes/down", HeroController, :move_down

    post "/heroes/attack", HeroController, :attack

    get "/game", HeroController, :game
  end

  # Other scopes may use custom stacks.
  # scope "/api", AdventureTimeOnlineWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: AdventureTimeOnlineWeb.Telemetry
    end
  end
end

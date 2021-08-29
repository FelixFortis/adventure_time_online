defmodule AdventureTimeOnline.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      AdventureTimeOnlineWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: AdventureTimeOnline.PubSub},
      # Start the Endpoint (http/https)
      AdventureTimeOnlineWeb.Endpoint
      # Start a worker by calling: AdventureTimeOnline.Worker.start_link(arg)
      # {AdventureTimeOnline.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AdventureTimeOnline.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    AdventureTimeOnlineWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

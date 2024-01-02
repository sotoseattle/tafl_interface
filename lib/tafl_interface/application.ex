defmodule TaflInterface.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TaflInterfaceWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:tafl_interface, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TaflInterface.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TaflInterface.Finch},
      # Start a worker by calling: TaflInterface.Worker.start_link(arg)
      # {TaflInterface.Worker, arg},
      # Start to serve requests, typically the last entry
      TaflInterfaceWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TaflInterface.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TaflInterfaceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

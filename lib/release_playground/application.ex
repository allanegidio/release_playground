defmodule ReleasePlayground.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ReleasePlaygroundWeb.Telemetry,
      ReleasePlayground.Repo,
      {DNSCluster,
       query: Application.get_env(:release_playground, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ReleasePlayground.PubSub},
      # Start a worker by calling: ReleasePlayground.Worker.start_link(arg)
      # {ReleasePlayground.Worker, arg},
      # Start to serve requests, typically the last entry
      ReleasePlaygroundWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ReleasePlayground.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ReleasePlaygroundWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

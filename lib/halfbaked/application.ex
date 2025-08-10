defmodule Halfbaked.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HalfbakedWeb.Telemetry,
      Halfbaked.Repo,
      {DNSCluster, query: Application.get_env(:halfbaked, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Halfbaked.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Halfbaked.Finch},
      # Start a worker by calling: Halfbaked.Worker.start_link(arg)
      # {Halfbaked.Worker, arg},
      # Start to serve requests, typically the last entry
      HalfbakedWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Halfbaked.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HalfbakedWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

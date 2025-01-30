defmodule ImageGenerator.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ImageGeneratorWeb.Telemetry,
      ImageGenerator.Repo,
      {DNSCluster, query: Application.get_env(:image_generator, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ImageGenerator.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ImageGenerator.Finch},
      # Start a worker by calling: ImageGenerator.Worker.start_link(arg)
      # {ImageGenerator.Worker, arg},
      # Start to serve requests, typically the last entry
      ImageGeneratorWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ImageGenerator.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ImageGeneratorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

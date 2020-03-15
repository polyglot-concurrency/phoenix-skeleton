defmodule Api.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    topologies = [
      basic: [
        strategy: Elixir.Cluster.Strategy.Consul.DNS,
        config: [
          service: "api.service.dc1.consul",
          application_name: "api",
          polling_interval: 1_000,
        ]
      ]
    ]

    children = [
      {Cluster.Supervisor, [topologies, [name: Chat.ClusterSupervisor]]},
      ApiWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Api.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

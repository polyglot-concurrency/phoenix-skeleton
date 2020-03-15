defmodule ApiWeb.HealthController do
  use ApiWeb, :controller

  ## Controller Actions

  require Logger

  @doc false
  def hello(conn, _params) do

    m = %{
      status: 1,
      message: "Hello world!",
    }

    Logger.info("hello: #{inspect(m)}")

    node_data = %{
      node_name: node(),
      nodes: Node.list(),
    }

    conn
    |> text(inspect(node_data))
  end

  @doc false
  def check(conn, _params) do
    conn
    |> text("Ok")
  end
end

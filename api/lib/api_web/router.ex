defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApiWeb do
    pipe_through :api

    get("/hello", HealthController, :hello)
    get("/check", HealthController, :check)
  end
end

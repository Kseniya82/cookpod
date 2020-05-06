defmodule CookpodWeb.Router do
  use CookpodWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug BasicAuth, use_config: {:cookpod, :basic_auth}
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :set_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug CookpodWeb.AuthPlug
  end

  scope "/", CookpodWeb do
    pipe_through :browser

    resources "/session", SessionController, only: [:new, :create, :delete], singleton: true
    resources "/users", UserController, only: [:new, :create]
    resources "/recipes", RecipeController
  end

  scope "/", CookpodWeb do
    pipe_through [:browser, :protected]

    get "/", PageController, :index
    get "/terms", PageController, :terms
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", CookpodWeb.Api, as: :api do
    pipe_through :api
    resources "/recipes", RecipeController, only: [:index, :show]
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :cookpod, swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Cookpod"
      },
      basePath: "/api/v1"
    }
  end

  defp set_current_user(conn, _params) do
    current_user = get_session(conn, :current_user)
    assign(conn, :current_user, current_user)
  end
end

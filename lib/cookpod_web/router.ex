defmodule CookpodWeb.Router do
  use CookpodWeb, :router
  use Plug.ErrorHandler

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
  end

  scope "/", CookpodWeb do
    pipe_through [:browser, :protected]

    get "/", PageController, :index
    get "/terms", PageController, :terms
  end

  # Other scopes may use custom stacks.
  # scope "/api", CookpodWeb do
  #   pipe_through :api
  # end

  def handle_errors(conn, %{kind: :error, reason: %Phoenix.Router.NoRouteError{}}) do
    conn
    |> handle_prepare
    |> render("404.html")
  end

  def handle_errors(conn, %{kind: :error, reason: %Phoenix.ActionClauseError{}}) do
    conn
    |> handle_prepare
    |> render("422.html")
  end

  def handle_errors(conn, _) do
    conn
  end

  def handle_prepare(conn) do
    conn
    |> fetch_session()
    |> fetch_flash()
    |> put_layout({CookpodWeb.LayoutView, :app})
    |> put_view(CookpodWeb.ErrorView)
  end

  defp set_current_user(conn, _params) do
    current_user = get_session(conn, :current_user)
    assign(conn, :current_user, current_user)
  end
end

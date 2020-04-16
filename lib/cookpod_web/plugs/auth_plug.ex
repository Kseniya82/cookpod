defmodule CookpodWeb.AuthPlug do
  @moduledoc """
  Plug for authorization
  """

  import Plug.Conn, only: [get_session: 2, halt: 1, assign: 3]
  import Phoenix.Controller, only: [redirect: 2]

  alias CookpodWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = get_session(conn, :current_user)

    case current_user do
      nil ->
        conn
        |> halt()
        |> redirect(to: Routes.session_path(conn, :new))

      _ ->
        conn
        |> assign(:current_user, current_user)
    end
  end
end

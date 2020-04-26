defmodule CookpodWeb.SessionController do
  use CookpodWeb, :controller
  alias Cookpod.User
  alias Cookpod.Repo

  def new(conn, _params) do
    changeset = User.new_changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    user = Repo.get_by(User, email: email)

    case Argon2.check_pass(user, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user)
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, _} ->
        text(conn, "ERROR!")
    end 
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_user)
    |> redirect(to: Routes.page_path(conn, :index))
  end
end

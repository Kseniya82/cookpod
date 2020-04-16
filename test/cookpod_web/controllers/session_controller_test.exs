defmodule CookpodWeb.SessionControllerTest do
  use CookpodWeb.ConnCase
  import Plug.Test

  @username Application.get_env(:cookpod, :basic_auth)[:username]
  @password Application.get_env(:cookpod, :basic_auth)[:password]

  defp using_basic_auth(conn, username, password) do
    header_content = "Basic " <> Base.encode64("#{username}:#{password}")
    put_req_header(conn, "authorization", header_content)
  end

  test "GET /session as logged in user", %{conn: conn} do
    conn =
      conn
      |> using_basic_auth(@username, @password)
      |> init_test_session(%{current_user: "test-user"})
      |> get(Routes.session_path(conn, :show))

    assert html_response(conn, 200) =~ "You are logged in"
  end

  test "GET /session", %{conn: conn} do
    conn =
      conn
      |> using_basic_auth(@username, @password)
      |> get("/session")

    assert html_response(conn, 200) =~ "You are not logged in"
  end

  test "GET /session/new", %{conn: conn} do
    conn =
      conn
      |> using_basic_auth(@username, @password)
      |> get("/session/new")

    assert html_response(conn, 200) =~ "Submit"
    assert html_response(conn, 200) =~ "Name"
    assert html_response(conn, 200) =~ "Password"
  end

  test "post /session/", %{conn: conn} do
    conn =
      conn
      |> using_basic_auth(@username, @password)
      |> put_req_header("content-type", "application/x-www-form-urlencoded")
      |> post("/session", "user%5Bname%5D=John&user%5Bpassword%5D=123")

    assert redirected_to(conn, 302) =~ "/"
    conn = get(recycle(conn), "/")
    assert html_response(conn, 200) =~ "Successfully logined as"
  end

  test "GET /session without basic auth credentials prevents access", %{conn: conn} do
    conn = get(conn, "/session")

    assert response(conn, 401) =~ "401 Unauthorized"
  end
end
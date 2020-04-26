defmodule CookpodWeb.SessionControllerTest do
  use CookpodWeb.ConnCase
  import Plug.Test

  @username Application.get_env(:cookpod, :basic_auth)[:username]
  @password Application.get_env(:cookpod, :basic_auth)[:password]

  defp using_basic_auth(conn, username, password) do
    header_content = "Basic " <> Base.encode64("#{username}:#{password}")
    put_req_header(conn, "authorization", header_content)
  end

  test "GET /session/new", %{conn: conn} do
    conn =
      conn
      |> using_basic_auth(@username, @password)
      |> get("/session/new")

    assert html_response(conn, 200) =~ "Submit"
    assert html_response(conn, 200) =~ "Email"
    assert html_response(conn, 200) =~ "Password"
  end

  test "post /session/", %{conn: conn} do
    conn =
      conn
      |> using_basic_auth(@username, @password)
      |> init_test_session(%{current_user: %{email: "user@cookpod.com", password: "123123"}})
      |> put_req_header("content-type", "application/x-www-form-urlencoded")
      |> post("/sessions", "user%5Bemail%5D=user%40cookpod.com&user%5Bpassword%5D=123123")

    conn = get(recycle(conn), "/")
    assert html_response(conn, 200) =~ "You are logged in as"
  end
end

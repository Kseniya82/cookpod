defmodule CookpodWeb.PageControllerTest do
  use CookpodWeb.ConnCase

  @username Application.get_env(:cookpod, :basic_auth)[:username]
  @password Application.get_env(:cookpod, :basic_auth)[:password]

  defp using_basic_auth(conn, username, password) do
    header_content = "Basic " <> Base.encode64("#{username}:#{password}")
    conn |> put_req_header("authorization", header_content)
  end

  test "GET /", %{conn: conn} do
    conn =
      conn
      |> using_basic_auth(@username, @password)
      |> get("/")

    assert html_response(conn, 302) =~ "redirected"
  # это странно
  end

  test "GET /terms for unauthorized user", %{conn: conn} do
    conn =
      conn
      |> using_basic_auth(@username, @password)
      |> get("/terms")

    assert html_response(conn, 302) =~ "redirected"
  end

  test "GET / without basic auth credentials prevents access", %{conn: conn} do
    conn =
      conn
      |> get("/")

    assert response(conn, 401) =~ "401 Unauthorized"
  end

  test "GET /terms without basic auth credentials prevents access", %{conn: conn} do
    conn =
      conn
      |> get("/terms")

    assert response(conn, 401) =~ "401 Unauthorized"
  end
end

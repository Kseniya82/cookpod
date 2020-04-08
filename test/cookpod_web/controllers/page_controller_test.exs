defmodule CookpodWeb.PageControllerTest do
  use CookpodWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Добро пожаловать в Phoenix!"
  end

  test "GET /terms", %{conn: conn} do
    conn = get(conn, "/terms")
    assert html_response(conn, 200)
  end
end

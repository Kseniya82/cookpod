defmodule CookpodWeb.ErrorViewTest do
  use CookpodWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(CookpodWeb.ErrorView, "404.html", []) =~ "Not found"
  end

  test "renders 422.html" do
    assert render_to_string(CookpodWeb.ErrorView, "422.html", []) =~ "Unprocessable Entity"
  end

  test "renders 500.html" do
    assert render_to_string(CookpodWeb.ErrorView, "500.html", []) == "Internal Server Error"
  end
end

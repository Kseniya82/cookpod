defmodule CookpodWeb.RecipeControllerTest do
  use CookpodWeb.ConnCase

  alias Cookpod.Recipies

  import Plug.Test

  @username Application.get_env(:cookpod, :basic_auth)[:username]
  @password Application.get_env(:cookpod, :basic_auth)[:password]

  @create_attrs %{
    description: "some description",
    name: "some name",
    picture: "some picture"
  }

  @update_attrs %{
    description: "some updated description",
    name: "some updated name",
    picture: "some updated picture"
  }

  @invalid_attrs %{
    description: nil,
    name: nil,
    picture: nil
  }

  defp using_basic_auth(conn, username, password) do
    header_content = "Basic " <> Base.encode64("#{username}:#{password}")
    put_req_header(conn, "authorization", header_content)
  end

  defp prepare(conn) do
    conn
    |> init_test_session(%{current_user: %{email: "user@test.ru", password: "123123"}})
    |> using_basic_auth(@username, @password)
  end

  def fixture(:recipe) do
    {:ok, recipe} = Recipies.create_recipe(@create_attrs)
    recipe
  end

  describe "index" do
    test "lists all recipes", %{conn: conn} do
      conn
      |> prepare()
      |> get(Routes.recipe_path(conn, :index))

      assert html_response(conn, 200) =~ "Listing Recipes"
    end
  end

  describe "new recipe" do
    test "renders form", %{conn: conn} do
      conn
      |> prepare()
      |> get(conn, Routes.recipe_path(conn, :new))

      assert html_response(conn, 200) =~ "New Recipe"
    end
  end

  describe "create recipe" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn
      |> prepare()
      |> post(conn, Routes.recipe_path(conn, :create), recipe: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.recipe_path(conn, :show, id)

      conn = get(conn, Routes.recipe_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Recipe"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn
      |> prepare()
      |> post(conn, Routes.recipe_path(conn, :create), recipe: @invalid_attrs)

      assert html_response(conn, 200) =~ "New Recipe"
    end
  end

  describe "edit recipe" do
    setup [:create_recipe]

    test "renders form for editing chosen recipe", %{conn: conn, recipe: recipe} do
      conn
      |> prepare()
      |> get(conn, Routes.recipe_path(conn, :edit, recipe))

      assert html_response(conn, 200) =~ "Edit Recipe"
    end
  end

  describe "update recipe" do
    setup [:create_recipe]

    test "redirects when data is valid", %{conn: conn, recipe: recipe} do
      conn
      |> prepare()
      |> put(conn, Routes.recipe_path(conn, :update, recipe), recipe: @update_attrs)

      assert redirected_to(conn) == Routes.recipe_path(conn, :show, recipe)

      conn = get(conn, Routes.recipe_path(conn, :show, recipe))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, recipe: recipe} do
      conn
      |> prepare()
      |> put(conn, Routes.recipe_path(conn, :update, recipe), recipe: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Recipe"
    end
  end

  describe "delete recipe" do
    setup [:create_recipe]

    test "deletes chosen recipe", %{conn: conn, recipe: recipe} do
      conn
      |> prepare()
      |> delete(conn, Routes.recipe_path(conn, :delete, recipe))

      assert redirected_to(conn) == Routes.recipe_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.recipe_path(conn, :show, recipe))
      end
    end
  end

  defp create_recipe(_) do
    recipe = fixture(:recipe)
    {:ok, recipe: recipe}
  end
end

defmodule CookpodWeb.Api.RecipeControllerTest do
  use CookpodWeb.ConnCase
  use PhoenixSwagger.SchemaTest, "priv/static/swagger.json"

  alias Cookpod.Recipes

  describe "get all recipes" do
    test "GET /api/v1/recipes", %{conn: conn, swagger_schema: schema} do
      conn
      |> get(Routes.api_recipe_path(conn, :index))
      |> validate_resp_schema(schema, "RecipesResponse")
      |> json_response(200)
    end
  end

  describe "get one recipe" do
    setup [:create_recipe]

    test "GET /api/v1/recipes/:id", %{conn: conn, recipe: recipe, swagger_schema: schema} do
      conn
      |> get(Routes.api_recipe_path(conn, :show, recipe))
      |> validate_resp_schema(schema, "RecipeResponse")
      |> json_response(200)
    end
  end

  defp create_recipe(_) do
    {:ok, recipe} = Recipes.create_recipe(%{name: "Test Recipe", description: "Test Description"})
    {:ok, %{recipe: recipe}}
  end
end

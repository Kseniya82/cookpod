defmodule CookpodWeb.Api.RecipeController do
  use CookpodWeb, :controller
  use PhoenixSwagger

  alias Cookpod.Recipes

  def swagger_definitions do
    %{
      Recipe:
        swagger_schema do
          title("Recipe")
          description("Steps describe how to cook")

          properties do
            id(:integer, "Recipe ID", required: true)
            name(:string, "Recipe name", required: true)
            description(:string, "Recipe description", required: true)
            picture([:string, "null"], "Recipe picture")
          end

          example(%{
            id: 123,
            name: "Sandwich",
            description: "Take corn bread, some butter and make it!"
          })
        end,
      RecipesResponse:
        swagger_schema do
          title("RecipesResponse")
          description("Response schema for multiple recipe")
          property(:data, Schema.array(:Recipe), "The recipe details")
        end,
      RecipeResponse:
        swagger_schema do
          title("RecipeResponse")
          description("Response schema for single recipe")
          property(:data, Schema.ref(:Recipe), "The recipe details")
        end
    }
  end

  swagger_path :index do
    get("/recipes")
    description("List recipes")
    response(200, "Success", Schema.array(:Recipe))
  end

  def index(conn, _params) do
    render(conn, "index.json", recipes: Recipes.list_recipes())
  end

  swagger_path :show do
    get("/recipes/{id}")
    description("Show recipe")
    parameter(:id, :path, :integer, "ID", required: true, example: 123)
    response(200, "Success", Schema.ref(:Recipe))
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.json", recipe: Recipes.get_recipe!(id))
  end
end

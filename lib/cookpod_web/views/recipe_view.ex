defmodule CookpodWeb.RecipeView do
  use CookpodWeb, :view
  
  alias Cookpod.Recipes.Uploaders.Picture
  alias CookpodWeb.Endpoint

  def picture_url(recipe) do
    do_picture_url(recipe.picture, recipe)
  end

  defp do_picture_url(nil, _) do
    nil
  end

  defp do_picture_url(picture, recipe) do
    Endpoint.url() <> Picture.url({picture, recipe})
  end
end

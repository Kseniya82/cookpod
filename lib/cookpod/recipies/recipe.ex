defmodule Cookpod.Recipies.Recipe do
  @moduledoc false
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  alias Cookpod.Recipes.Uploaders.Picture

  schema "recipes" do
    field :description, :string
    field :name, :string
    field :picture, Picture.Type

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :description])
    |> cast_attachments(attrs, [:picture])
    |> validate_required([:name, :description])
    |> unique_constraint(:name)
  end
end

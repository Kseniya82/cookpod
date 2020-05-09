defmodule Cookpod.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: Cookpod.Repo

  alias Cookpod.User
  alias Cookpod.Recipes.Recipe

  def user_factory do
    password = sequence(:password, &"password#{&1}")
    password_hash = Argon2.hash_pwd_salt(password)

    %User{
      email: sequence(:email, &"email-#{&1}@example.com"),
      password: password,
      password_hash: password_hash
    }
  end

  def recipe_factory do
    %Recipe{
      name: sequence(:name, &"recipe-name#{&1}"),
      description: sequence(:description, &"recipe-description#{&1}")
    }
  end
end

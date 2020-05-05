defmodule Cookpod.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_length(:password, min: 4)
    |> validate_confirmation(:password)
    |> validate_format(:email, ~r/@/)
    |> encrypt_password()
    |> unique_constraint(:email)
  end

  def new_changeset() do
    changeset(%Cookpod.User{}, %{})
  end

  def encrypt_password(changeset) do
    case Map.fetch(changeset.changes, :password) do
      {:ok, password} ->
        put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))

      :error ->
        changeset
    end
  end
end

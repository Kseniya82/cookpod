# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Cookpod.Repo.insert!(%Cookpod.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Cookpod.Repo
alias Cookpod.User

users = [
  %{email: "user@cookpod.com", password: "123123", password_confirmation: "123123"},
  %{email: "admin@cookpod.com", password: "123123", password_confirmation: "123123"}
]

Enum.each(users, fn user ->
  Repo.insert!(User.changeset(%User{}, user))
end)

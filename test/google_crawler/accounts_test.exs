defmodule GoogleCrawler.AccountsTest do
  use GoogleCrawler.DataCase

  alias GoogleCrawler.Accounts
  alias GoogleCrawler.UserFactory

  describe "users" do
    alias GoogleCrawler.Accounts.User

    test "get_user/1 returns the user with given id" do
      user = UserFactory.create()

      assert user.id == Accounts.get_user(user.id).id
    end

    test "create_user/1 with valid data creates a user" do
      user_attrs = UserFactory.build_attrs()

      assert {:ok, %User{} = user} = Accounts.create_user(user_attrs)
      assert user.email == user_attrs.email
      assert user.username == user_attrs.username
      assert user.encrypted_password != nil
    end

    test "create_user/1 with invalid data returns error changeset" do
      user_attrs = UserFactory.build_attrs(%{email: nil, username: nil, password: nil})

      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(user_attrs)
    end
  end
end

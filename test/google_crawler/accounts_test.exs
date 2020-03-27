defmodule GoogleCrawler.AccountsTest do
  use GoogleCrawler.DataCase

  alias GoogleCrawler.Accounts
  alias GoogleCrawler.UserFactory

  describe "users" do
    alias GoogleCrawler.Accounts.User

    test "get_user/1 returns the user with given id" do
      user = UserFactory.create()

      assert Accounts.get_user(user.id).id == user.id
    end

    test "get_user/1 returns nil when the user does not exist" do
      assert Accounts.get_user(1) == nil
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

  describe "user auth" do
    test "auth_user/1 returns the user when the credentials are valid" do
      user = UserFactory.create(%{email: "bob@email.com", password: "bob_password", password_confirmation: "bob_password"})

      assert {:ok, user} = Accounts.auth_user("bob@email.com", "bob_password")
    end

    test "auth_user/1 returns the error message when the credentials are invalid" do
      user = UserFactory.create(%{email: "bob@email.com", password: "bob_password", password_confirmation: "bob_password"})

      assert {:error, "invalid password"} = Accounts.auth_user("bob@email.com", "wrong_password")
    end
  end
end

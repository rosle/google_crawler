defmodule GoogleCrawler.AccountsTest do
  use GoogleCrawler.DataCase

  alias GoogleCrawler.Accounts
  alias GoogleCrawler.UserFactory

  describe "users" do
    alias GoogleCrawler.Accounts.User

    test "list_users/0 returns all users" do
      user = UserFactory.create()

      user_id =
        Accounts.list_users()
        |> List.first
        |> Map.get(:id)

      assert user_id == user.id
    end

    test "get_user!/1 returns the user with given id" do
      user = UserFactory.create()

      assert user.id == Accounts.get_user!(user.id).id
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

    test "update_user/2 with valid data updates the user" do
      user = UserFactory.create()
      new_user_attrs = UserFactory.build_attrs()

      assert {:ok, %User{} = user} = Accounts.update_user(user, new_user_attrs)
      assert user.email == new_user_attrs.email
      assert user.username == new_user_attrs.username
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = UserFactory.create()
      new_user_attrs = UserFactory.build_attrs(%{email: nil, username: nil, password: nil})

      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, new_user_attrs)
      assert user.id == Accounts.get_user!(user.id).id
    end

    test "delete_user/1 deletes the user" do
      user = UserFactory.create()

      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = UserFactory.create()

      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end

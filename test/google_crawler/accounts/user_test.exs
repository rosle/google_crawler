defmodule GoogleCrawler.Accounts.UserTest do
  use GoogleCrawler.DataCase

  alias GoogleCrawler.UserFixtures
  alias GoogleCrawler.Accounts
  alias GoogleCrawler.Accounts.User

  describe "changeset" do
    test "email is required" do
      attrs = UserFixtures.build(%{email: ""})
      changeset = User.changeset(%User{}, attrs)

      refute changeset.valid?
      assert %{email: ["can't be blank"]} = errors_on(changeset)
    end

    test "username is required" do
      attrs = UserFixtures.build(%{username: ""})
      changeset = User.changeset(%User{}, attrs)

      refute changeset.valid?
      assert %{username: ["can't be blank"]} = errors_on(changeset)
    end

    test "email must contain @" do
      attrs = UserFixtures.build(%{email: "invalid_email"})
      changeset = User.changeset(%User{}, attrs)

      refute changeset.valid?
      assert %{email: ["has invalid format"]} = errors_on(changeset)
    end

    test "password must be at least 6 characters" do
      attrs = UserFixtures.build(%{password: "12345"})
      changeset = User.changeset(%User{}, attrs)

      refute changeset.valid?
      assert %{password: ["should be at least 6 character(s)"]} = errors_on(changeset)
    end

    test "password confirmation must match with password" do
      attrs = UserFixtures.build(%{password: "123456", password_confirmation: "123457"})
      changeset = User.changeset(%User{}, attrs)

      refute changeset.valid?
      assert %{password_confirmation: ["does not match confirmation"]} = errors_on(changeset)
    end

    test "email must be unique" do
      _existing_user = UserFixtures.create(%{email: "bob@email.com"})
      attrs = UserFixtures.build(%{email: "bob@email.com"})

      assert {:error, changeset} = Accounts.create_user(attrs)
      assert %{email: ["has already been taken"]} = errors_on(changeset)
    end

    test "username must be unique" do
      _existing_user = UserFixtures.create(%{username: "bob"})
      attrs = UserFixtures.build(%{username: "bob"})

      assert {:error, changeset} = Accounts.create_user(attrs)
      assert %{username: ["has already been taken"]} = errors_on(changeset)
    end
  end

  describe "registration changeset" do
    test "password is required" do
      attrs = UserFixtures.build(%{password: ""})
      changeset = User.registration_changeset(%User{}, attrs)

      refute changeset.valid?
      assert %{password: ["can't be blank"]} = errors_on(changeset)
    end

    test "password must be encrypted" do
      attrs = UserFixtures.build()
      changeset = User.registration_changeset(%User{}, attrs)

      assert get_change(changeset, :encrypted_password) != nil
    end
  end
end

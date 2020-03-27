defmodule GoogleCrawler.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias GoogleCrawler.Repo

  alias GoogleCrawler.Accounts.User

  @doc """
  Gets a single user.

  Returns nil if the user does not exist.

  ## Examples

      iex> get_user(123)
      %User{}

      iex> get_user(456)
      nil

  """
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Get a single user by the specified attributes

  ## Examples

    iex> get_user_by(123)
      %User{}
    iex> get_user_by(456)
      nil

  """
  def get_user_by(attrs), do: Repo.get_by(User, attrs)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Authenticate the user with email and password
  Bcrypt checkpass returns the reason when the auth is failed, which could be
  - invalid user-identifier
  - invalid password

  ## Examples

      iex> auth_user("bob@email.com", "valid_password")
      {:ok, $User{}}

      iex> auth_user("bob@email.com", "invalid_password")
      {:error, "invalid password"}

  """
  def auth_user(email, password) do
    get_user_by(email: email)
    |> Bcrypt.check_pass(password)
  end
end

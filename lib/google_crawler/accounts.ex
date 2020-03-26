defmodule GoogleCrawler.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias GoogleCrawler.Repo

  alias GoogleCrawler.Accounts.User

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

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

      iex> authenticate_user(%{"email" => "bob@email.com", "passowrd" => "valid_password"})
      {:ok, $User{}}

      iex> authenticate_user(%{"email" => "bob@email.com", "passowrd" => "invalid_password"})
      {:error, "invalid password"}

      iex> authenticate_user(%{})
      {:error, "invalid parameters"}
  """
  def authenticate_user(%{"email" => email, "password" => password}) do
    get_user_by(email: email)
    |> Bcrypt.check_pass(password)
  end

  def authenticate_user(_params), do: {:error, "invalid parameters"}
end

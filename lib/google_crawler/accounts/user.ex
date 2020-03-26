defmodule GoogleCrawler.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :username, :string
    field :encrypted_password, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @fields ~w(email username encrypted_password password password_confirmation)a

  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, @fields)
    |> validate_required([:email, :username])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  def registration_changeset(user, attrs \\ %{}) do
    user
    |> changeset(attrs)
    |> validate_required([:password])
    |> encrypt_password
  end

  defp encrypt_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    put_change(changeset, :encrypted_password, Bcrypt.hash_pwd_salt(password))
  end

  defp encrypt_password(changeset), do: changeset
end

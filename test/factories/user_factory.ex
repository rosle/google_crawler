defmodule GoogleCrawler.UserFactory do
  alias GoogleCrawler.Accounts

  def default_attrs do
    %{
      email: FakerElixir.Internet.email,
      username: FakerElixir.Internet.user_name,
      password: "123456",
      password_confirmation: "123456"
    }
  end

  def build_attrs(attrs \\ %{}) do
    Enum.into(attrs, default_attrs())
  end

  def create(attrs \\ %{}) do
    user_attrs = build_attrs(attrs)
    {:ok, user} = Accounts.create_user(user_attrs)

    user
  end
end

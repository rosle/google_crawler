defmodule GoogleCrawlerWeb.SetUserTest do
  use GoogleCrawlerWeb.ConnCase
  use Plug.Test
  import GoogleCrawlerWeb.Plugs.SetUser

  alias GoogleCrawler.Accounts.User
  alias GoogleCrawler.UserFactory

  test "assigns the user with the given id to the conn if the session user id exists" do
    user = UserFactory.create()

    conn =
      build_conn()
      |> init_test_session(user_id: user.id)
      |> call(%{})

    assert conn.assigns.user.id == user.id
    assert conn.assigns.user.email == user.email
    assert conn.assigns.user.username == user.username
    assert conn.assigns.user_signed_in? == true
  end

  test "assigns the user as nil to the conn if the session user id does not exist" do
    conn =
      build_conn()
      |> init_test_session(%{})
      |> call(%{})

    assert conn.assigns.user == nil
    assert conn.assigns.user_signed_in? == false
  end
end

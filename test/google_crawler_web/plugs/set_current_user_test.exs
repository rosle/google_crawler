defmodule GoogleCrawlerWeb.SetCurrentUserTest do
  use GoogleCrawlerWeb.ConnCase
  import GoogleCrawlerWeb.Plugs.SetCurrentUser

  alias GoogleCrawler.UserFactory

  test "assigns the user with the given id to the conn if the session user id exists" do
    user = UserFactory.create()

    conn =
      build_conn()
      |> init_test_session(current_user_id: user.id)
      |> call(%{})

    assert conn.assigns.current_user.id == user.id
    assert conn.assigns.current_user.email == user.email
    assert conn.assigns.current_user.username == user.username
    assert conn.assigns.user_signed_in? == true
  end

  test "assigns the user as nil to the conn if the session user id does not exist" do
    conn =
      build_conn()
      |> init_test_session(%{})
      |> call(%{})

    assert conn.assigns.current_user == nil
    assert conn.assigns.user_signed_in? == false
  end
end

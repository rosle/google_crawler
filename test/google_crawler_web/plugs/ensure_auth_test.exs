defmodule GoogleCrawlerWeb.EnsureAuthTest do
  use GoogleCrawlerWeb.ConnCase
  import GoogleCrawlerWeb.Plugs.EnsureAuth

  alias GoogleCrawler.UserFactory

  test "allows the user to access the page if the user has already logged in" do
    user = UserFactory.create()

    conn =
      build_authenticated_conn(user)
      |> call(%{})

    refute conn.halted
  end

  test "redirects to the login page if the user has not logged in" do
    conn =
      build_conn()
      |> init_test_session(%{})
      |> fetch_flash
      |> assign(:user_signed_in?, false)
      |> call(%{})

    assert conn.halted
    assert redirected_to(conn) == Routes.session_path(conn, :new)
    assert get_flash(conn, :error) == "You need to sign in or sign up before continuing."
  end
end

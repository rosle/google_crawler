defmodule GoogleCrawlerWeb.RequireAuthTest do
  use GoogleCrawlerWeb.ConnCase
  use Plug.Test
  import GoogleCrawlerWeb.Plugs.RequireAuth

  alias GoogleCrawler.Accounts.User
  alias GoogleCrawler.UserFactory

  test "allows the user to access the page if the user has already logged in" do
    user = UserFactory.create()

    conn =
      build_conn()
      |> init_test_session(user_id: user.id)
      |> bypass_through(Rumbl.Router, :browser)
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

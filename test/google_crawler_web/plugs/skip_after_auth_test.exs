defmodule GoogleCrawlerWeb.SkipAfterAuthTest do
  use GoogleCrawlerWeb.ConnCase
  import GoogleCrawlerWeb.Plugs.SkipAfterAuth

  alias GoogleCrawler.UserFactory

  test "redirects to the user dashboard if the user has already logged in" do
    user = UserFactory.create()

    conn =
      build_conn()
      |> init_test_session(current_user_id: user.id)
      |> fetch_flash
      |> assign(:user_signed_in?, true)
      |> call(%{})

    assert conn.halted
    assert redirected_to(conn) == Routes.dashboard_path(conn, :index)
    assert get_flash(conn, :info) == "You are already signed in."
  end

  test "allow the user to access the page if the user has not logged in" do
    conn =
      build_conn()
      |> init_test_session(%{})
      |> assign(:user_signed_in?, false)
      |> call(%{})

    refute conn.halted
  end
end

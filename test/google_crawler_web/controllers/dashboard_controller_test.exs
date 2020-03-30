defmodule GoogleCrawlerWeb.DashboardControllerTest do
  use GoogleCrawlerWeb.ConnCase

  alias GoogleCrawler.UserFactory

  test "GET / renders the index template", %{conn: conn} do
    user = UserFactory.create()

    conn =
      conn
      |> init_test_session(%{})
      |> put_session(:current_user_id, user.id)
      |> get(Routes.dashboard_path(conn, :index))

    assert html_response(conn, 200) =~ "Upload your keyword file"
  end

  test "GET / redirects to the login page if the user has not logged in", %{conn: conn} do
    conn =
      conn
      |> init_test_session(%{})
      |> get(Routes.dashboard_path(conn, :index))

    assert redirected_to(conn) == Routes.session_path(conn, :new)
  end
end

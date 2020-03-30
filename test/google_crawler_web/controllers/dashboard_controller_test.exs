defmodule GoogleCrawlerWeb.DashboardControllerTest do
  use GoogleCrawlerWeb.ConnCase

  alias GoogleCrawler.UserFactory

  test "GET / renders the index template with upload keyword form", %{conn: conn} do
    user = UserFactory.create()

    conn =
      build_authenticated_conn(user)
      |> get(Routes.dashboard_path(conn, :index))

    assert html_response(conn, 200) =~ "Upload your keyword file"
  end

  test "GET / redirects to the login page if the user has not logged in", %{conn: conn} do
    conn =
      conn
      |> get(Routes.dashboard_path(conn, :index))

    assert redirected_to(conn) == Routes.session_path(conn, :new)
  end
end

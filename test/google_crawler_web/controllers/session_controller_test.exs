defmodule GoogleCrawlerWeb.SessionControllerTest do
  use GoogleCrawlerWeb.ConnCase

  alias GoogleCrawler.UserFactory

  test "new/2 renders the new template", %{conn: conn} do
    conn = get(conn, Routes.session_path(conn, :new))

    assert html_response(conn, 200) =~ "Sign in"
  end

  describe "create/2" do
    test "redirects to pages controller when user credentials are valid", %{conn: conn} do
      user = UserFactory.create()

      conn =
        post(conn, Routes.session_path(conn, :create),
          user: %{email: user.email, password: user.password}
        )

      assert redirected_to(conn) == Routes.page_path(conn, :index)
      assert get_flash(conn, :info) == "Welcome back"
      assert get_session(conn, :current_user_id) == user.id
    end

    test "renders the error when user credentials are invalid", %{conn: conn} do
      user = UserFactory.create()

      conn =
        post(conn, Routes.session_path(conn, :create),
          user: %{email: user.email, password: "invalid_password"}
        )

      assert redirected_to(conn) == Routes.session_path(conn, :new)
      assert get_flash(conn, :error) == "The email or password is incorrect, please try again"
    end
  end
end

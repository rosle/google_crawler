defmodule GoogleCrawlerWeb.SessionControllerTest do
  use GoogleCrawlerWeb.ConnCase

  alias GoogleCrawler.UserFactory

  test "new/2 renders the new template", %{conn: conn} do
    conn = get(conn, Routes.session_path(conn, :new))

    assert html_response(conn, 200) =~ "Sign in"
  end

  test "new/2 redirects to the page controller if the user has already logged in", %{conn: conn} do
    user = UserFactory.create()

    conn =
      conn
      |> init_test_session(%{})
      |> put_session(:current_user_id, user.id)
      |> get(Routes.session_path(conn, :new))

    assert redirected_to(conn) == Routes.dashboard_path(conn, :index)
  end

  describe "create/2" do
    test "redirects to page controller when user credentials are valid", %{conn: conn} do
      user = UserFactory.create()

      conn =
        post(conn, Routes.session_path(conn, :create),
          user: %{email: user.email, password: user.password}
        )

      assert redirected_to(conn) == Routes.dashboard_path(conn, :index)
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

  test "delete/2 clears the user session and redirects to the log in page", %{conn: conn} do
    user = UserFactory.create()

    conn =
      conn
      |> init_test_session(%{})
      |> put_session(:current_user_id, user.id)
      |> delete(Routes.session_path(conn, :delete, user))

    assert get_session(conn, :current_user_id) == nil
    assert get_session(conn, :current_user) == nil
    assert get_session(conn, :user_signed_in?) == nil
    assert redirected_to(conn) == Routes.session_path(conn, :new)
  end
end

defmodule GoogleCrawlerWeb.RegistrationControllerTest do
  use GoogleCrawlerWeb.ConnCase

  alias GoogleCrawler.UserFactory

  test "new/2 renders the new template", %{conn: conn} do
    conn = get(conn, Routes.registration_path(conn, :new))

    assert html_response(conn, 200) =~ "Create Account"
  end

  test "new/2 redirects to the pages controller if the user has already logged in", %{conn: conn} do
    user = UserFactory.create()

    conn =
      conn
      |> init_test_session(%{})
      |> put_session(:current_user_id, user.id)
      |> get(Routes.registration_path(conn, :new))

    assert redirected_to(conn) == Routes.page_path(conn, :index)
  end

  describe "create/2" do
    test "redirects to page index when the data is valid", %{conn: conn} do
      user_attrs = UserFactory.build_attrs()

      conn = post(conn, Routes.registration_path(conn, :create, user: user_attrs))

      assert redirected_to(conn) == Routes.page_path(conn, :index)
      assert get_flash(conn, :info) == "You have signed up successfully!"
    end

    test "renders the error when the data is invalid", %{conn: conn} do
      user_attrs = UserFactory.build_attrs(%{email: nil, username: nil, password: nil})

      conn = post(conn, Routes.registration_path(conn, :create, user: user_attrs))

      assert html_response(conn, 200) =~ "Create Account"
    end
  end
end

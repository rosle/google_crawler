defmodule GoogleCrawlerWeb.RegistrationControllerTest do
  use GoogleCrawlerWeb.ConnCase

  alias GoogleCrawler.UserFixtures

  test "new/2 renders the new template", %{conn: conn} do
    conn = get(conn, Routes.registration_path(conn, :new))

    assert html_response(conn, 200) =~ "Create Account"
  end

  describe "create/2" do
    test "redirects to page index when the data is valid", %{conn: conn}  do
      user_attrs = UserFixtures.build_attrs()

      conn = post(conn, Routes.registration_path(conn, :create, user: user_attrs))

      assert %{} = redirected_params(conn)
      assert redirected_to(conn) == Routes.page_path(conn, :index)
      assert get_flash(conn, :info) == "You have signed up successfully!"
    end

    test "renders the error when the data is invalid", %{conn: conn}  do
      user_attrs = UserFixtures.build_attrs(%{email: nil, username: nil, password: nil})

      conn = post(conn, Routes.registration_path(conn, :create, user: user_attrs))

      assert html_response(conn, 200) =~ "Create Account"
    end
  end
end

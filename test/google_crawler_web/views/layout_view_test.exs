defmodule GoogleCrawlerWeb.LayoutViewTest do
  use GoogleCrawlerWeb.ConnCase, async: true

  alias GoogleCrawlerWeb.LayoutView

  test "body_class returns current controller and action as a class name", %{conn: conn} do
    conn = get(build_conn(), Routes.registration_path(conn, :new))

    body_class_name = LayoutView.body_class(conn)

    assert body_class_name == "registration new"
  end
end

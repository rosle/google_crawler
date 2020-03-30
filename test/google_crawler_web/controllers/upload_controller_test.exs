defmodule GoogleCrawlerWeb.UploadControllerTest do
  use GoogleCrawlerWeb.ConnCase

  alias GoogleCrawler.UserFactory

  test "create/2 renders csv content as text if the keyword file is valid", %{conn: conn} do
    user = UserFactory.create()
    upload_file = upload_file_fixture("keyword_files/valid_keyword.csv")

    conn =
      build_authenticated_conn(user)
      |> post(Routes.upload_path(conn, :create), %{keyword_file: %{file: upload_file}})

    assert text_response(conn, 200) == "elixir, ruby, javascript"
  end

  test "create/2 raises error if the file is failed to parse" do
    user = UserFactory.create()
    upload_file = upload_file_fixture("keyword_files/invalid_keyword.csv")

    conn = build_authenticated_conn(user)

    assert_raise CSV.RowLengthError, fn ->
      post(conn, Routes.upload_path(conn, :create), %{keyword_file: %{file: upload_file}})
    end
  end

  test "create/2 redirects to the user dashboard with an error message if the file is not supported",
       %{conn: conn} do
    user = UserFactory.create()
    upload_file = upload_file_fixture("keyword_files/unsupported_keyword.txt")

    conn =
      build_authenticated_conn(user)
      |> post(Routes.upload_path(conn, :create), %{keyword_file: %{file: upload_file}})

    assert redirected_to(conn) == Routes.dashboard_path(conn, :index)
    assert get_flash(conn, :error) == "Invalid file, please select again."
  end

  defp upload_file_fixture(path) do
    path = Path.join(["test/fixtures", path])

    %Plug.Upload{
      content_type: MIME.from_path(path),
      filename: Path.basename(path),
      path: path
    }
  end
end

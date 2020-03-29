defmodule GoogleCrawlerWeb.UploadController do
  use GoogleCrawlerWeb, :controller
  import Ecto.Changeset, only: [get_change: 3]

  alias GoogleCrawler.Search.KeywordFile

  def create(conn, %{"keyword_file" => keyword_file}) do
    changeset = KeywordFile.changeset(%KeywordFile{}, keyword_file)

    if changeset.valid? do
      # TODO: Parse CSV
      file = get_change(changeset, :file, nil)
      file.path
    else
      conn
      |> put_flash(:error, gettext("Invalid file, please select again."))
      |> redirect(to: Routes.dashboard_path(conn, :index))
    end
  end
end

defmodule GoogleCrawlerWeb.DashboardController do
  use GoogleCrawlerWeb, :controller

  alias GoogleCrawler.Search.KeywordFile

  def index(conn, _params) do
    changeset = KeywordFile.changeset(%KeywordFile{})

    render(conn, "index.html", changeset: changeset)
  end
end

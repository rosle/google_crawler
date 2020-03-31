defmodule GoogleCrawlerWeb.DashboardController do
  use GoogleCrawlerWeb, :controller

  alias GoogleCrawler.Search
  alias GoogleCrawler.Search.KeywordFile

  def index(conn, _params) do
    keywords = Search.list_user_keywords(conn.assigns.current_user)
    changeset = KeywordFile.changeset(%KeywordFile{})

    render(conn, "index.html", keywords: keywords, changeset: changeset)
  end
end

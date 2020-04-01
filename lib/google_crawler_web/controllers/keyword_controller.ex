defmodule GoogleCrawlerWeb.KeywordController do
  use GoogleCrawlerWeb, :controller

  alias GoogleCrawler.Search

  def show(conn, %{"id" => id}) do
    keyword = Search.get_keyword(id)

    render(conn, "show.html", keyword: keyword)
  end
end

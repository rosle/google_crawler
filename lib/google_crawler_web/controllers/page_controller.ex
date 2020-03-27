defmodule GoogleCrawlerWeb.PageController do
  use GoogleCrawlerWeb, :controller

  plug GoogleCrawlerWeb.Plugs.RequireAuth

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

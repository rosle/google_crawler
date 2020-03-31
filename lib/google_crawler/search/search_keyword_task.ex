defmodule GoogleCrawler.Search.SearchKeywordTask do
  alias GoogleCrawler.Search.Crawler
  alias GoogleCrawler.Search.Scapper

  def perform(%{keyword: keyword}) do
    # Update the status to in progress

    case Crawler.fetch(keyword) do
      {:ok, body} ->
        Scapper.scrap(body)
        # Store the result to the db

      {:error, reason} ->
        # TODO: Retry the task
    end
  end
end

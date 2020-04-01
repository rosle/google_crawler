defmodule GoogleCrawler.Search.SearchKeywordTask do
  alias GoogleCrawler.Search.Crawler
  alias GoogleCrawler.Search.Keyword

  def perform(%Keyword{} = keyword) do
    # Update the status to in progress

    case Crawler.fetch(keyword.keyword) do
      {:ok, body} ->
        # Store the result to the db
        IO.inspect(body)

      {:error, reason} ->
        # TODO: Retry the task
        IO.inspect(reason)
    end
  end
end

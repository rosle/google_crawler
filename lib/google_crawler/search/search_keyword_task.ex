defmodule GoogleCrawler.Search.SearchKeywordTask do
  alias GoogleCrawler.Search
  alias GoogleCrawler.Search.Keyword
  alias GoogleCrawler.Search.PageFetcher
  alias GoogleCrawler.Search.PageScrapper

  def perform(%Keyword{} = keyword) do
    # Update the status to in progress
    Search.update_keyword(keyword, %{status: :in_progress})

    case PageFetcher.fetch(keyword.keyword) do
      {:ok, body} ->
        # Store the result to the db
        result = PageScrapper.scrap(body)
        IO.inspect result
        Search.update_keyword(keyword, %{
          status: :completed,
          raw_html_result: result.raw_html_result
        })

      {:error, reason} ->
        # TODO: Retry the task
        IO.inspect(reason)
    end
  end
end

defmodule GoogleCrawler.Search.SearchKeywordTask do
  alias GoogleCrawler.Search
  alias GoogleCrawler.Search.Keyword
  alias GoogleCrawler.Search.PageFetcher
  alias GoogleCrawler.Search.PageScrapper

  def perform(%Keyword{} = keyword) do
    Search.update_keyword(keyword, %{status: :in_progress})

    case PageFetcher.fetch(keyword.keyword) do
      {:ok, body} ->
        result = PageScrapper.scrap(body)
        Search.update_keyword(keyword, %{
          status: :completed,
          raw_html_result: result.raw_html_result
        })

      {:error, reason} ->
        Search.update_keyword(keyword, %{ status: :failed })
        raise "Keyword search failed: #{reason}"
    end
  end
end

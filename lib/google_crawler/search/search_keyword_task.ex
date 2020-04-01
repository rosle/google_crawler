defmodule GoogleCrawler.Search.SearchKeywordTask do
  alias GoogleCrawler.Search.Keyword
  alias GoogleCrawler.Search.PageFetcher
  alias GoogleCrawler.Search.PageScrapper

  def perform(%Keyword{} = keyword) do
    case PageFetcher.fetch(keyword.keyword) do
      {:ok, body} ->
        PageScrapper.scrap(body)

      {:error, reason} ->
        raise "Keyword search failed: #{reason}"
    end
  end
end

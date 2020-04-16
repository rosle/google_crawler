defmodule GoogleCrawler.Search.SearchKeywordTask do
  alias GoogleCrawler.Search.Keyword
  alias GoogleCrawler.Google.Scraper

  def perform(%Keyword{} = keyword) do
    case google_api_client().search(keyword.keyword) do
      {:ok, body} ->
        Scraper.scrap(body)

      {:error, reason} ->
        raise "Keyword search failed: #{reason}"
    end
  end

  defp google_api_client do
    Application.get_env(:google_crawler, :google_api_client)
  end
end

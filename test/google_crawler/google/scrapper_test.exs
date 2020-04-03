defmodule GoogleCrawler.Google.ScrapperTest do
  use ExUnit.Case

  alias GoogleCrawler.Google.Scrapper
  alias GoogleCrawler.Google.ScrapperResult

  test "scrap/1" do
    html = response_fixtures("hotels.html")

    result = Scrapper.scrap(html)

    IO.inspect result
    # assert %ScrapperResult{
    #          raw_html_result: html
    #        } == result
  end

  defp response_fixtures(path) do
    Path.join(["test/fixtures/search_results", path])
    |> File.read!()
  end
end

defmodule GoogleCrawler.Google.ScraperTest do
  use ExUnit.Case

  alias GoogleCrawler.Google.Scraper
  alias GoogleCrawler.Google.ScraperResult

  test "scrap/1" do
    html = response_fixtures("hotels.html")

    result = Scraper.scrap(html)
    raw_html = cleanup_html(html)

    assert %ScraperResult{
             raw_html_result: ^raw_html,
             total_results: 5_970_000_000,
             links: [
               "https://www.hotels.com/",
               "https://www.booking.com/city/th/bangkok.html",
               "https://www.tripadvisor.com/Hotels-g293916-Bangkok-Hotels.html",
               "https://www.agoda.com/city/bangkok-th.html",
               "https://www.agoda.com/country/thailand.html",
               "https://www.expedia.co.th/en/Bangkok-Hotels.d178236.Travel-Guide-Hotels",
               "http://www.bangkok.com/hotels/",
               "https://www.trivago.com/bangkok-519/hotel",
               "https://www.hotelscombined.com/Place/Bangkok.htm"
             ],
             total_links: 9,
             top_ads_links: [
               "https://www.booking.com/"
             ],
             total_top_ads_links: 1,
             bottom_ads_links: [],
             total_bottom_ads_links: 0
           } = result
  end

  defp response_fixtures(path) do
    Path.join(["test/fixtures/search_results", path])
    |> File.read!()
  end

  defp cleanup_html(html) do
    html
    |> String.chunk(:printable)
    |> Enum.filter(&String.printable?/1)
    |> Enum.join()
  end
end

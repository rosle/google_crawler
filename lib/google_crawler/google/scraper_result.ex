defmodule GoogleCrawler.Google.ScraperResult do
  defstruct raw_html_result: nil,
            total_results: 0,
            links: [],
            total_links: 0,
            top_ads_links: [],
            total_top_ads_links: 0,
            bottom_ads_links: [],
            total_bottom_ads_links: 0
end

defmodule GoogleCrawler.Google.Scrapper do
  alias GoogleCrawler.Google.ScrapperResult

  @selectors %{
    total_results: "#result-stats",
    non_ads_links: "div.r > a",
    top_ads_links: "#tads .ads-ad > .ad_cclk > a.V0MxL",
    bottom_ads_links: "#bottomads .ads-ad > .ad_cclk > a.V0MxL"
  }

  def scrap(html) do
    result = %ScrapperResult{}

    {:ok, document} = Floki.parse_document(html)

    parse_raw_html_result(result, html)
    |> parse_total_results(document)
    |> parse_non_ads_links(document)
    |> parse_top_ads_links(document)
    |> parse_bottom_ads_links(document)
  end

  defp parse_total_results(result, document) do
    total_results_text = Floki.find(document, @selectors.total_results) |> Floki.text()

    total_results =
      Regex.named_captures(~r/About (?<total_result>.*) results/, total_results_text)
      |> Map.get("total_result")
      |> String.replace(",", "")
      |> Integer.parse()
      |> elem(0)

    %{result | total_results: total_results}
  end

  defp parse_non_ads_links(result, document) do
    non_ads_links =
      document
      |> Floki.find(@selectors.non_ads_links)
      |> Floki.attribute("href")

    %{result | links: non_ads_links, total_links: length(non_ads_links)}
  end

  defp parse_top_ads_links(result, document) do
    top_ads_links =
      document
      |> Floki.find(@selectors.top_ads_links)
      |> Floki.attribute("href")

    %{result | top_ads_links: top_ads_links, total_top_ads_links: length(top_ads_links)}
  end

  defp parse_bottom_ads_links(result, document) do
    bottom_ads_links =
      document
      |> Floki.find(@selectors.bottom_ads_links)
      |> Floki.attribute("href")

    %{
      result
      | bottom_ads_links: bottom_ads_links,
        total_bottom_ads_links: length(bottom_ads_links)
    }
  end

  defp parse_raw_html_result(result, html) do
    %{result | raw_html_result: cleanup_html(html)}
  end

  defp cleanup_html(html) do
    html
    |> String.chunk(:printable)
    |> Enum.filter(&String.printable?/1)
    |> Enum.join()
  end
end

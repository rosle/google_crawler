defmodule GoogleCrawler.Google.ScrapperResult do
  defstruct raw_html_result: nil,
            total_results: 0
end

defmodule GoogleCrawler.Google.Scrapper do
  alias GoogleCrawler.Google.ScrapperResult

  # @selectors %{
  #   total_result: "#result-stats"
  # }

  def scrap(html) do
    result = %ScrapperResult{}

    {:ok, document} = Floki.parse_document(html)

    parse_raw_html_result(result, html)
    |> parse_total_results(document)
  end

  def parse_total_results(result, document) do
    total_results_text = Floki.find(document, "#result-stats") |> Floki.text

    total_results =
      Regex.named_captures(~r/About (?<total_result>.*) results/, total_results_text)
      |> Map.get("total_result")
      |> String.replace(",", "")
      |> Integer.parse
      |> elem(0)

    %{ result | total_results: total_results }
  end

  def parse_raw_html_result(result, html) do
    %{ result | raw_html_result: cleanup_html(html) }
  end

  def cleanup_html(html) do
    html
    |> String.chunk(:printable)
    |> Enum.filter(&String.printable?/1)
    |> Enum.join()
  end
end

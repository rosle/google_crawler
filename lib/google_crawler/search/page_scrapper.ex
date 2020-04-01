defmodule GoogleCrawler.Search.PageScrapper do
  def scrap(html) do
    # TODO: Scrap the page content
    %{
      raw_html_result: cleanup_html(html)
    }
  end

  def cleanup_html(html) do
    html
    |> String.chunk(:printable)
    |> Enum.filter(&String.printable?/1)
    |> Enum.join
  end
end

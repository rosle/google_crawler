defmodule GoogleCrawler.ScrapperResultFactory do
  def default_attrs(total_links, total_top_ads_links, total_bottom_ads_links) do
    total_links = total_links || Enum.random(0..10)
    total_top_ads_links = total_top_ads_links || Enum.random(0..5)
    total_bottom_ads_links = total_bottom_ads_links || Enum.random(0..5)

    %{
      raw_html_result: FakerElixir.Lorem.sentences(10..20),
      total_results: Enum.random(100_000..200_000),
      links: build_link(total_links),
      total_links: total_links,
      top_ads_links: build_link(total_top_ads_links),
      total_top_ads_links: total_top_ads_links,
      bottom_ads_links: build_link(total_bottom_ads_links),
      total_bottom_ads_links: total_bottom_ads_links
    }
  end

  def build_attrs(attrs \\ %{}) do
    Enum.into(
      attrs,
      default_attrs(
        attrs[:total_links],
        attrs[:total_top_ads_links],
        attrs[:total_bottom_ads_links]
      )
    )
  end

  defp build_link(count) do
    for _ <- 0..(count - 1), do: FakerElixir.Internet.url()
  end
end

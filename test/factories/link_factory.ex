defmodule GoogleCrawler.LinkFactory do
  alias GoogleCrawler.Repo
  alias GoogleCrawler.Search.Link
  alias GoogleCrawler.KeywordFactory

  def default_attrs do
    %{
      url: FakerElixir.Internet.url(),
      is_ads: false
    }
  end

  def build_attrs(attrs \\ %{}) do
    Enum.into(attrs, default_attrs())
  end

  def create(attrs \\ %{}, keyword \\ KeywordFactory.create()) do
    link_attrs = build_attrs(attrs)

    {:ok, link} =
      Ecto.build_assoc(keyword, :links)
      |> Link.changeset(link_attrs)
      |> Repo.insert()

    link
  end
end

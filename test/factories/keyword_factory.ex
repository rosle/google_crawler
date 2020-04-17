defmodule GoogleCrawler.KeywordFactory do
  alias GoogleCrawler.Search

  def default_attrs do
    %{
      keyword: FakerElixir.Lorem.word()
    }
  end

  def build_attrs(attrs \\ %{}) do
    Enum.into(attrs, default_attrs())
  end

  def create(attrs \\ %{}) do
    keyword_attrs = build_attrs(attrs)

    {:ok, keyword} = Search.create_keyword(keyword_attrs)

    keyword
  end
end

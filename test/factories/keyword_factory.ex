defmodule GoogleCrawler.KeywordFactory do
  alias GoogleCrawler.Search
  alias GoogleCrawler.UserFactory

  def default_attrs do
    %{
      keyword: FakerElixir.Lorem.word()
    }
  end

  def build_attrs(attrs \\ %{}) do
    Enum.into(attrs, default_attrs())
  end

  def create(attrs \\ %{}, user \\ UserFactory.create()) do
    keyword_attrs = build_attrs(attrs)

    {:ok, keyword} = Search.create_keyword(keyword_attrs, user)

    keyword
  end
end

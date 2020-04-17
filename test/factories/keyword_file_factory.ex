defmodule GoogleCrawler.KeywordFileFactory do
  import GoogleCrawler.FixtureHelper

  def default_attrs do
    %{
      file: upload_file_fixture("keyword_files/invalid_keyword.csv")
    }
  end

  def build_attrs(attrs \\ %{}) do
    Enum.into(attrs, default_attrs())
  end
end

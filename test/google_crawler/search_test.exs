defmodule GoogleCrawler.SearchTest do
  use GoogleCrawler.DataCase

  alias GoogleCrawler.Search
  alias GoogleCrawler.Search.Keyword
  alias GoogleCrawler.KeywordFactory
  alias GoogleCrawler.UserFactory

  describe "keywords" do
    test "list_keywords/0 returns all keywords" do
      keyword = KeywordFactory.create()

      assert Search.list_keywords() |> Enum.map(&Map.get(&1, :keyword)) == [keyword.keyword]
    end

    test "get_keyword/1 returns the keyword with given id" do
      keyword = KeywordFactory.create()

      assert Search.get_keyword(keyword.id).keyword == keyword.keyword
    end

    test "create_keyword/1 with valid data creates a keyword" do
      user = UserFactory.create()
      keyword_attrs = KeywordFactory.build_attrs(%{keyword: "elixir"})

      assert {:ok, %Keyword{} = keyword} = Search.create_keyword(keyword_attrs, user)
      assert keyword.keyword == "elixir"
    end

    test "create_keyword/1 with invalid data returns error changeset" do
      user = UserFactory.create()
      keyword_attrs = KeywordFactory.build_attrs(%{keyword: ""})

      assert {:error, %Ecto.Changeset{}} = Search.create_keyword(keyword_attrs, user)
    end
  end

  describe "keyword file" do
    test "parse_keywords_from_file!/2 returns the stream" do
      csv_stream =
        Search.parse_keywords_from_file!(
          "test/fixtures/keyword_files/valid_keyword.csv",
          "text/csv"
        )

      assert Enum.to_list(csv_stream) == [["elixir"], ["ruby"], ["javascript"]]
    end

    test "parse_keywords_from_file!/2 raises an exception when the file type is not supported" do
      assert_raise GoogleCrawler.Errors.FileNotSupportedError, fn ->
        Search.parse_keywords_from_file!(
          "test/fixtures/keyword_files/unsupported_keyword.txt",
          "text/plain"
        )
      end
    end
  end
end

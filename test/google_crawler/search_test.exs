defmodule GoogleCrawler.SearchTest do
  use GoogleCrawler.DataCase

  alias GoogleCrawler.Search

  describe "keywords" do
    alias GoogleCrawler.Search.Keyword

    @valid_attrs %{keyword: "some keyword"}
    @invalid_attrs %{keyword: nil}

    def keyword_fixture(attrs \\ %{}) do
      {:ok, keyword} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Search.create_keyword()

      keyword
    end

    test "list_keywords/0 returns all keywords" do
      keyword = keyword_fixture()
      assert Search.list_keywords() == [keyword]
    end

    test "get_keyword/1 returns the keyword with given id" do
      keyword = keyword_fixture()
      assert Search.get_keyword(keyword.id) == keyword
    end

    test "create_keyword/1 with valid data creates a keyword" do
      assert {:ok, %Keyword{} = keyword} = Search.create_keyword(@valid_attrs)
      assert keyword.keyword == "some keyword"
    end

    test "create_keyword/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Search.create_keyword(@invalid_attrs)
    end
  end
end

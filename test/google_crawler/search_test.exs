defmodule GoogleCrawler.SearchTest do
  use GoogleCrawler.DataCase

  alias GoogleCrawler.Search
  alias GoogleCrawler.Search.Keyword
  alias GoogleCrawler.Google.ScrapperResult
  alias GoogleCrawler.KeywordFactory
  alias GoogleCrawler.ScrapperResultFactory
  alias GoogleCrawler.UserFactory

  describe "keywords" do
    test "list_user_keywords/0 returns all keywords" do
      user1 = UserFactory.create()
      user2 = UserFactory.create()
      keyword1 = KeywordFactory.create(%{}, user1)
      _keyword2 = KeywordFactory.create(%{}, user2)

      user_keywords = Search.list_user_keywords(user1)

      assert user_keywords |> Enum.map(&Map.get(&1, :keyword)) == [keyword1.keyword]
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
      assert keyword.status == :in_queue
      assert keyword.user_id == user.id
    end

    test "create_keyword/1 with invalid data returns error changeset" do
      user = UserFactory.create()
      keyword_attrs = KeywordFactory.build_attrs(%{keyword: ""})

      assert {:error, %Ecto.Changeset{}} = Search.create_keyword(keyword_attrs, user)
    end

    test "create_and_search_keyword/2 with valid data creates the keyword and triggers the task to search the keyword" do
      user = UserFactory.create()
      keyword_attrs = KeywordFactory.build_attrs()

      assert {:ok, %Keyword{}} = Search.create_and_search_keyword(keyword_attrs, user)
      assert GoogleCrawler.SearchKeywordWorker.get_state() != %{}
    end

    test "create_and_search_keyword/2 with invalid data creates the keyword and triggers the task to search the keyword" do
      user = UserFactory.create()
      keyword_attrs = KeywordFactory.build_attrs(%{keyword: ""})

      assert {:error, %Ecto.Changeset{}} = Search.create_and_search_keyword(keyword_attrs, user)
    end

    test "update_keyword/2 with valid data updates the keyword" do
      keyword = KeywordFactory.create()
      keyword_attrs = %{keyword: "new", status: :in_progress}

      assert {:ok, %Keyword{} = keyword} = Search.update_keyword(keyword, keyword_attrs)
      assert keyword.keyword == "new"
      assert keyword.status == :in_progress
    end

    test "update_keyword/2 with invalid data returns error changeset" do
      keyword = KeywordFactory.create()
      keyword_attrs = %{keyword: "", status: :invalid}

      assert {:error, %Ecto.Changeset{}} = Search.update_keyword(keyword, keyword_attrs)
      assert Repo.get_by(Keyword, keyword: keyword.keyword) != nil
    end

    test "update_keyword_result_from_scrapper/2 updates the keyword results and associates the keyword links" do
      keyword = KeywordFactory.create()

      scrapper_result =
        struct(
          ScrapperResult,
          ScrapperResultFactory.build_attrs(
            total_results: 50_000,
            total_links: 10,
            total_top_ads_links: 3,
            total_bottom_ads_links: 1
          )
        )

      Search.update_keyword_result_from_scrapper(keyword, scrapper_result)

      # Keyword result summary is updated
      assert %{
               total_results: 50_000,
               total_links: 10,
               total_ads_links: 4
             } = Search.get_keyword(keyword.id)

      # Top Ads links is inserted
      top_ads_query = [is_ads: true, ads_position: :top]
      top_ads_links = get_link_urls(Search.list_keyword_links(keyword, top_ads_query))
      assert 3 = length(top_ads_links)
      assert scrapper_result.top_ads_links == top_ads_links

      # Bottom Ads links is inserted
      bottom_ads_query = [is_ads: true, ads_position: :bottom]
      bottom_ads_links = get_link_urls(Search.list_keyword_links(keyword, bottom_ads_query))
      assert 1 = length(bottom_ads_links)
      assert scrapper_result.bottom_ads_links == bottom_ads_links

      # Non-Ads links is inserted
      non_ads_query = [is_ads: false]
      links = get_link_urls(Search.list_keyword_links(keyword, non_ads_query))
      assert 10 = length(links)
      assert scrapper_result.links == links
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

  defp get_link_urls(links) do
    Enum.map(links, &Map.get(&1, :url))
  end
end

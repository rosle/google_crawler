defmodule Googlecrawler.Search.KeywordTest do
  use GoogleCrawler.DataCase

  alias GoogleCrawler.Search.Keyword
  alias GoogleCrawler.UserFactory
  alias GoogleCrawler.KeywordFactory

  describe "changeset" do
    test "keyword is required" do
      user = UserFactory.create()
      attrs = KeywordFactory.build_attrs(%{keyword: "", user: user})
      changeset = Keyword.changeset(%Keyword{}, attrs)

      refute changeset.valid?
      assert %{keyword: ["can't be blank"]} = errors_on(changeset)
    end

    test "user is required" do
      attrs = KeywordFactory.build_attrs()
      changeset = Keyword.changeset(%Keyword{}, attrs)

      refute changeset.valid?
      assert %{user_id: ["can't be blank"]} = errors_on(changeset)
    end

    test "status is required" do
      user = UserFactory.create()
      attrs = KeywordFactory.build_attrs(%{status: nil, user: user})
      changeset = Keyword.changeset(%Keyword{}, attrs)

      refute changeset.valid?
      assert %{status: ["can't be blank"]} = errors_on(changeset)
    end

    test "status is valid" do
      attrs = KeywordFactory.build_attrs(%{status: :invalid})
      changeset = Keyword.changeset(%Keyword{}, attrs)

      refute changeset.valid?
      assert %{status: ["is invalid"]} = errors_on(changeset)
    end
  end

  describe "update result changeset" do
    test "raw_html_result is required" do
      attrs = KeywordFactory.build_attrs(%{raw_html_result: ""})
      changeset = Keyword.update_result_changeset(%Keyword{}, attrs)

      refute changeset.valid?
      assert %{raw_html_result: ["can't be blank"]} = errors_on(changeset)
    end

    test "total_results is required" do
      attrs = KeywordFactory.build_attrs(%{total_results: ""})
      changeset = Keyword.update_result_changeset(%Keyword{}, attrs)

      refute changeset.valid?
      assert %{total_results: ["can't be blank"]} = errors_on(changeset)
    end

    test "total_results is a number" do
      attrs = KeywordFactory.build_attrs(%{total_results: "invalid"})
      changeset = Keyword.update_result_changeset(%Keyword{}, attrs)

      refute changeset.valid?
      assert %{total_results: ["is invalid"]} = errors_on(changeset)
    end

    test "total_results is greater than or equal to 0" do
      attrs = KeywordFactory.build_attrs(%{total_results: -1})
      changeset = Keyword.update_result_changeset(%Keyword{}, attrs)

      refute changeset.valid?
      assert %{total_results: ["must be greater than or equal to 0"]} = errors_on(changeset)
    end

    test "total_ads_links is required" do
      attrs = KeywordFactory.build_attrs(%{total_ads_links: ""})
      changeset = Keyword.update_result_changeset(%Keyword{}, attrs)

      refute changeset.valid?
      assert %{total_ads_links: ["can't be blank"]} = errors_on(changeset)
    end

    test "total_ads_links is a number" do
      attrs = KeywordFactory.build_attrs(%{total_ads_links: "invalid"})
      changeset = Keyword.update_result_changeset(%Keyword{}, attrs)

      refute changeset.valid?
      assert %{total_ads_links: ["is invalid"]} = errors_on(changeset)
    end

    test "total_ads_links is greater than or equal to 0" do
      attrs = KeywordFactory.build_attrs(%{total_ads_links: -1})
      changeset = Keyword.update_result_changeset(%Keyword{}, attrs)

      refute changeset.valid?
      assert %{total_ads_links: ["must be greater than or equal to 0"]} = errors_on(changeset)
    end

    test "total_links is required" do
      attrs = KeywordFactory.build_attrs(%{total_links: ""})
      changeset = Keyword.update_result_changeset(%Keyword{}, attrs)

      refute changeset.valid?
      assert %{total_links: ["can't be blank"]} = errors_on(changeset)
    end

    test "total_links is a number" do
      attrs = KeywordFactory.build_attrs(%{total_links: "invalid"})
      changeset = Keyword.update_result_changeset(%Keyword{}, attrs)

      refute changeset.valid?
      assert %{total_links: ["is invalid"]} = errors_on(changeset)
    end

    test "total_links is greater than or equal to 0" do
      attrs = KeywordFactory.build_attrs(%{total_links: -1})
      changeset = Keyword.update_result_changeset(%Keyword{}, attrs)

      refute changeset.valid?
      assert %{total_links: ["must be greater than or equal to 0"]} = errors_on(changeset)
    end
  end
end

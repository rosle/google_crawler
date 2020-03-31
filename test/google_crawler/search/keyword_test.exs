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
  end
end
defmodule Googlecrawler.Search.LinkTest do
  use GoogleCrawler.DataCase

  alias GoogleCrawler.LinkFactory
  alias GoogleCrawler.Search.Link

  describe "changeset" do
    test "url is required" do
      attrs = LinkFactory.build_attrs(%{url: ""})
      changeset = Link.changeset(%Link{}, attrs)

      refute changeset.valid?
      assert %{url: ["can't be blank"]} = errors_on(changeset)
    end

    test "is_ads is required" do
      attrs = LinkFactory.build_attrs(%{is_ads: nil})
      changeset = Link.changeset(%Link{}, attrs)

      refute changeset.valid?
      assert %{is_ads: ["can't be blank"]} = errors_on(changeset)
    end

    test "ads position is required if the link is ads" do
      attrs = LinkFactory.build_attrs(%{is_ads: true, ads_position: nil})
      changeset = Link.changeset(%Link{}, attrs)

      refute changeset.valid?
      assert %{ads_position: ["can't be blank"]} = errors_on(changeset)
    end

    test "ads position is valid" do
      attrs = LinkFactory.build_attrs(%{is_ads: true, ads_position: :left})
      changeset = Link.changeset(%Link{}, attrs)

      refute changeset.valid?
      # TODO: Recheck the validations
      assert %{ads_position: ["is invalid"]} = errors_on(changeset)
    end
  end
end

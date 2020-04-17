defmodule GoogleCrawler.KeywordFileTest do
  use GoogleCrawler.DataCase

  import GoogleCrawler.FixtureHelper

  alias GoogleCrawler.KeywordFileFactory
  alias GoogleCrawler.Search.KeywordFile

  describe "changeset" do
    test "file is required" do
      attrs = KeywordFileFactory.build_attrs(%{file: nil})
      changeset = KeywordFile.changeset(%KeywordFile{}, attrs)

      refute changeset.valid?
      assert %{file: ["can't be blank"]} = errors_on(changeset)
    end

    test "file is in the allowed extensions" do
      attrs =
        KeywordFileFactory.build_attrs(%{
          file: upload_file_fixture("keyword_files/unsupported_keyword.txt")
        })

      changeset = KeywordFile.changeset(%KeywordFile{}, attrs)

      refute changeset.valid?
      assert %{file: ["is not supported"]} = errors_on(changeset)
    end
  end
end

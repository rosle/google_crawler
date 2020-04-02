defmodule GoogleCrawler.Search.SearchKeywordTaskTest do
  use ExUnit.Case

  alias GoogleCrawler.Search.Keyword
  alias GoogleCrawler.Search.SearchKeywordTask

  test "perform/1 returns the scapping result when it is success" do
    assert %{raw_html_result: result} = SearchKeywordTask.perform(%Keyword{keyword: "elixir"})
  end

  test "perform/1 raises an error reason when it is failed" do
    assert_raise RuntimeError, fn ->
      SearchKeywordTask.perform(%Keyword{keyword: "error"})
    end
  end
end

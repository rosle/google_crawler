defmodule GoogleCrawler.Search.SearchKeywordWorkerTest do
  use ExUnit.Case
  use GoogleCrawler.DataCase

  alias GoogleCrawler.SearchKeywordWorker
  alias GoogleCrawler.Search
  alias GoogleCrawler.KeywordFactory

  test "search/1 performs search task with the given keyword id" do
    keyword = KeywordFactory.create(%{})

    task = SearchKeywordWorker.search(keyword.id)
    task_ref = task.ref

    assert %{^task_ref => {keyword, 0}} = SearchKeywordWorker.get_state()
    assert Search.get_keyword(keyword.id).status == :in_progress

    :timer.sleep(1000)
    assert SearchKeywordWorker.get_state() == %{}
  end

  test "search/1 updates the keyword result when the task is completed" do
    keyword = KeywordFactory.create(%{})

    SearchKeywordWorker.search(keyword.id)

    # Find a way to test without sleep 😔
    :timer.sleep(1000)

    keyword = Search.get_keyword(keyword.id)
    assert keyword.status == :completed
    assert keyword.raw_html_result != nil

    assert SearchKeywordWorker.get_state() == %{}
  end

  test "search/1 updates the keyword status to failed when the task is failed" do
    keyword = KeywordFactory.create(%{keyword: "error"})

    task = SearchKeywordWorker.search(keyword.id)
    task_ref = task.ref

    # Find a way to test without sleep 😔
    :timer.sleep(1000)

    assert Search.get_keyword(keyword.id).status == :failed
    assert SearchKeywordWorker.get_state() == %{}
  end
end

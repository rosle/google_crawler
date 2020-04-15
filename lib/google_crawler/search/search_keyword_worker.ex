defmodule GoogleCrawler.SearchKeywordWorker do
  use GenServer

  alias GoogleCrawler.Search
  alias GoogleCrawler.Search.Keyword
  alias GoogleCrawler.Google.ScrapperResult

  @max_retry_count 3

  # Client

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def search(keyword_id) do
    GenServer.call(__MODULE__, {:search, keyword_id})
  end

  def get_state do
    GenServer.call(__MODULE__, {:get_state})
  end

  # Server Callbacks

  def init(state) do
    {:ok, state}
  end

  def handle_call({:search, keyword_id}, _from, state) do
    keyword = Search.get_keyword(keyword_id)
    Search.update_keyword(keyword, %{status: :in_progress})

    # start task and store the state of the task with the retry count
    # as a tuple of {keyword, retry_count} -> {%Keyword{}, 1}
    task = start_task(keyword)
    new_state = Map.put(state, task.ref, {keyword, 0})

    {:reply, task, new_state}
  end

  def handle_call({:get_state}, _from, state) do
    {:reply, state, state}
  end

  def handle_info({ref, result}, state) do
    {keyword, _retry_count} = Map.get(state, ref)

    update_keyword_result(keyword, result)

    # Demonitor the task and remove from the state
    Process.demonitor(ref, [:flush])
    new_state = Map.delete(state, ref)

    {:noreply, new_state}
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, state) do
    {keyword, retry_count} = Map.get(state, ref)

    new_state =
      if retry_count < @max_retry_count do
        task = start_task(keyword)

        state
        |> Map.delete(ref)
        |> Map.put(task.ref, {keyword, retry_count + 1})
      else
        Search.update_keyword(keyword, %{status: :failed})
        Map.delete(state, ref)
      end

    {:noreply, new_state}
  end

  defp start_task(%Keyword{} = keyword) do
    Task.Supervisor.async_nolink(GoogleCrawler.TaskSupervisor, fn ->
      GoogleCrawler.Search.SearchKeywordTask.perform(keyword)
    end)
  end

  defp update_keyword_result(%Keyword{} = keyword, %ScrapperResult{} = result) do
    Search.update_keyword(keyword, %{
      status: :completed,
      raw_html_result: result.raw_html_result,
      total_results: result.total_results,
      total_ads_links: result.total_top_ads_links + result.total_bottom_ads_links,
      total_links: result.total_links
    })
  end
end

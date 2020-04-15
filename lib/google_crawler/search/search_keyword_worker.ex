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

    case Search.update_keyword_result_from_scrapper(keyword, result) do
      {:ok, _result} -> :ok
      {:error, _reason} -> send(self(), {:DOWN, ref, :process, self(), :failed_to_save_result})
    end

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
end

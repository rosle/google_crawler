defmodule GoogleCrawler.Task do
  def perform(task, args) do
    Task.Supervisor.start_child(GoogleCrawler.TaskSupervisor, fn ->
      task.perform(args)
    end, restart: :transient)
  end
end

defmodule GoogleCrawler.Google.MockApiClient do
  @behaviour GoogleCrawler.Google.ApiClientBehaviour

  def search("error") do
    {:error, "Bad request"}
  end

  def search(_keyword) do
    {:ok, response_fixtures('search_result.html')}
  end

  defp response_fixtures(path) do
    Path.join(["test/fixtures", path])
    |> File.read!()
  end
end

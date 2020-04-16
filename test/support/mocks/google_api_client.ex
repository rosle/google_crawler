defmodule GoogleCrawler.Google.MockApiClient do
  @behaviour GoogleCrawler.Google.ApiClientBehaviour

  def search("error") do
    {:error, "Bad request"}
  end

  def search(_keyword) do
    {:ok, response_fixtures('hotels.html')}
  end

  defp response_fixtures(path) do
    Path.join(["test/fixtures/search_results", path])
    |> File.read!()
  end
end

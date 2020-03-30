defmodule GoogleCrawler.Crawler do
  @url "https://www.google.com/search?q="

  def fetch(keyword) do
    case HTTPoison.get(@url <> keyword) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body

      {:error, %HTTPoison.Error{reason: reason}} ->
        raise GoogleCrawler.Errors.FetchError, message: reason
    end
  end
end

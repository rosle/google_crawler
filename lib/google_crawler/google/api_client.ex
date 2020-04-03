defmodule GoogleCrawler.Google.ApiClientBehaviour do
  @callback search(keyword :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
end

defmodule GoogleCrawler.Google.ApiClient do
  @behaviour GoogleCrawler.Google.ApiClientBehaviour

  @url "https://www.google.com/search?q="

  def search(keyword) do
    case HTTPoison.get(@url <> URI.encode(keyword)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{body: body}} ->
        {:error, body}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end

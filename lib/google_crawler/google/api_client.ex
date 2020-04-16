defmodule GoogleCrawler.Google.ApiClientBehaviour do
  @callback search(keyword :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
end

defmodule GoogleCrawler.Google.ApiClient do
  @behaviour GoogleCrawler.Google.ApiClientBehaviour

  @url "https://www.google.com/search?hl=en&q="
  @user_agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"

  def search(keyword) do
    case HTTPoison.get(@url <> URI.encode(keyword), request_headers()) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{body: body}} ->
        {:error, body}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def request_headers do
    [
      {"User-Agent", @user_agent}
    ]
  end
end

defmodule GoogleCrawler.Search.PageFetcher do
  @url "https://www.google.com/search?q="

  def fetch(keyword) do
    IO.puts "Performing search ... #{@url <> URI.encode(keyword)}"
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

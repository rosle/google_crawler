defmodule GoogleCrawler.Errors.FileNotSupportedError do
  defexception message: "File is not supported"
end

defmodule GoogleCrawler.Errors.FetchError do
  defexception message: "Fails to fetch the keyword result"
end

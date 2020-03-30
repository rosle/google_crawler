defmodule GoogleCrawler.Search do
  @moduledoc """
  The Search context.
  """

  import Ecto.Query, warn: false
  alias GoogleCrawler.Repo

  alias GoogleCrawler.Search.Keyword
  alias GoogleCrawler.Search.KeywordFile

  @doc """
  Returns the list of keywords.

  ## Examples

      iex> list_keywords()
      [%Keyword{}, ...]

  """
  def list_keywords do
    Repo.all(Keyword)
  end

  @doc """
  Gets a single keyword.

  Raises `Ecto.NoResultsError` if the Keyword does not exist.

  ## Examples

      iex> get_keyword!(123)
      %Keyword{}

      iex> get_keyword!(456)
      ** (Ecto.NoResultsError)

  """
  def get_keyword(id), do: Repo.get(Keyword, id)

  @doc """
  Creates a keyword.

  ## Examples

      iex> create_keyword(%{field: value})
      {:ok, %Keyword{}}

      iex> create_keyword(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_keyword(attrs \\ %{}) do
    %Keyword{}
    |> Keyword.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Parses the keyword from the given file.
  Returns the stream for each line in the csv file as [line_result].
  Raise an exception if the file content type is not supported or the file parsing is failed.

  ### Examples

      iex > parse_keywords_from_file!("var/folder/abcdef", "text/csv") |> Enum.to_list
      [ok: ["hotels"], ok: ["restaurants"]]

  """
  def parse_keywords_from_file!(file_path, content_type) do
    KeywordFile.parse!(file_path, content_type)
  end
end

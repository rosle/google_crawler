defmodule GoogleCrawler.Search do
  @moduledoc """
  The Search context.
  """

  import Ecto.Query, warn: false
  alias GoogleCrawler.Repo

  alias GoogleCrawler.Search.Keyword
  alias GoogleCrawler.Search.KeywordFile

  @doc """
  Returns the list of keywords belongs to the given user.

  ## Examples

      iex> list_user_keywords(user)
      [%Keyword{}, ...]

  """
  def list_user_keywords(user) do
    Keyword
    |> where(user_id: ^user.id)
    |> Repo.all()
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

      iex> create_keyword(%{field: value}, %User{})
      {:ok, %Keyword{}}

      iex> create_keyword(%{field: bad_value}, %User{})
      {:error, %Ecto.Changeset{}}

  """
  def create_keyword(attrs \\ %{}, user) do
    %Keyword{}
    |> Keyword.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Parses the keyword from the given file.
  Returns the stream for each line in the csv file as [line_result].
  Raise an exception if the file mime type is not supported or the file parsing is failed.

  ### Examples

      iex > parse_keywords_from_file!("var/folder/abcdef", "text/csv") |> Enum.to_list
      [ok: ["hotels"], ok: ["restaurants"]]

  """
  def parse_keywords_from_file!(file_path, mime_type) do
    KeywordFile.parse!(file_path, mime_type)
  end
end

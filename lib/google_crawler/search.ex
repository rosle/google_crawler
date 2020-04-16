defmodule GoogleCrawler.Search do
  @moduledoc """
  The Search context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias GoogleCrawler.Repo

  alias GoogleCrawler.Search.Keyword
  alias GoogleCrawler.Search.KeywordFile
  alias GoogleCrawler.Search.Link
  alias GoogleCrawler.Google.ScrapperResult

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
  def get_keyword(id) do
    Repo.get(Keyword, id)
    |> Repo.preload(:links)
  end

  @doc """
  Creates a keyword.

  ## Examples

      iex> create_keyword(%{field: value}, %User{})
      {:ok, %Keyword{}}

      iex> create_keyword(%{field: bad_value}, %User{})
      {:error, %Ecto.Changeset{}}

  """
  def create_keyword(attrs \\ %{}, user) do
    Ecto.build_assoc(user, :keywords)
    |> Keyword.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
    Save the keyword and perform the keyword search

    ## Examples

      iex> create_and_search_keyword(%{field: value}, %User{})
      {:ok, %Keyword{}}

      iex> create_and_search_keyword(%{field: bad_value}, %User{})
      {:error, %Ecto.Changeset{}}
  """
  def create_and_search_keyword(attrs \\ %{}, user) do
    case create_keyword(attrs, user) do
      {:ok, %Keyword{} = keyword} ->
        GoogleCrawler.SearchKeywordWorker.search(keyword.id)
        {:ok, %Keyword{}}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Updates a keyword.

  ## Examples

      iex> update_keyword(keyword, %{field: new_value})
      {:ok, %Keyword{}}

      iex> update_keyword(keyword, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_keyword(%Keyword{} = keyword, attrs \\ %{}) do
    keyword
    |> Keyword.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Update the search result for a keyword.

  ## Examples

      iex> update_keyword_result(keyword, %{field: new_value})
      {:ok, %Keyword{}}

      iex> update_keyword_result(keyword, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_keyword_result(%Keyword{} = keyword, attrs) do
    keyword
    |> Keyword.update_result_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Update the keyword result from the scrapper result and mark the keyword as completed.
  """
  def update_keyword_result_from_scrapper(%Keyword{} = keyword, %ScrapperResult{} = result) do
    keyword_changeset =
      Keyword.update_result_changeset(keyword, %{
        status: :completed,
        raw_html_result: result.raw_html_result,
        total_results: result.total_results,
        total_ads_links: result.total_top_ads_links + result.total_bottom_ads_links,
        total_links: result.total_links
      })

    Multi.new()
    |> create_keyword_link_multi(keyword, result.top_ads_links, %{
      is_ads: true,
      ads_position: :top
    })
    |> create_keyword_link_multi(keyword, result.bottom_ads_links, %{
      is_ads: true,
      ads_position: :bottom
    })
    |> create_keyword_link_multi(keyword, result.links, %{
      is_ads: false
    })
    |> Multi.update(:keyword, keyword_changeset)
    |> Repo.transaction()
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

  @doc """
  List result links of the given keyword.
  """
  def list_keyword_links(keyword, query \\ []) do
    Link
    |> where(keyword_id: ^keyword.id)
    |> where(^query)
    |> order_by(desc: :is_ads)
    |> Repo.all()
  end

  # TODO: Recheck how to document private functions
  # Create the multi to insert the links.
  # Other attributes of the link except the link itself must be specified
  defp create_keyword_link_multi(multi, _keyword, [], _attrs), do: multi

  defp create_keyword_link_multi(multi, keyword, [link | rest_of_links], attrs) do
    changeset =
      Ecto.build_assoc(keyword, :links)
      |> Link.changeset(Map.put(attrs, :url, link))

    multi
    |> Multi.insert("link_#{length(multi.operations)}", changeset)
    |> create_keyword_link_multi(keyword, rest_of_links, attrs)
  end
end

defmodule GoogleCrawlerWeb.UploadController do
  use GoogleCrawlerWeb, :controller
  import Ecto.Changeset, only: [get_change: 3]

  alias GoogleCrawler.Search
  alias GoogleCrawler.Search.KeywordFile

  def create(conn, %{"keyword_file" => keyword_file}) do
    changeset = KeywordFile.changeset(%KeywordFile{}, keyword_file)

    if changeset.valid? do
      file = get_change(changeset, :file, nil)

      Search.parse_keywords_from_file!(file.path, file.content_type)
      |> create_and_trigger_google_search
      |> put_error_flash_for_failed_keywords(conn)
      |> redirect(to: Routes.dashboard_path(conn, :index))
    else
      conn
      |> put_flash(:error, gettext("Invalid file, please select again."))
      |> redirect(to: Routes.dashboard_path(conn, :index))
    end
  end

  # TODO: Trigger the scrapper background worker
  defp create_and_trigger_google_search(csv_result) do
    csv_result
    |> Stream.map(fn keyword_row -> List.first(keyword_row) end)
    |> Stream.map(fn keyword -> %{keyword: keyword} end)
    |> Enum.map(&Search.create_keyword/1)
  end

  defp put_error_flash_for_failed_keywords(create_result, conn) do
    failed_keywords = failed_keywords(create_result)

    if length(failed_keywords) > 0 do
      conn
      |> put_flash(:error,
        gettext("Some keywords could not be created: %{failed_keywords}", failed_keywords: Enum.join(failed_keywords, ","))
      )
    else
      conn
    end
  end

  defp failed_keywords(create_result) do
    create_result
    |> Enum.filter(&match?({:error, _}, &1))
    |> Enum.map(fn error_tuple ->
      error_tuple
      |> elem(1)
      |> get_change(:keyword, nil)
    end)
  end
end

defmodule GoogleCrawler.Search.KeywordFile do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :file, :map
  end

  @accept_file_ext ~w(.csv)

  def changeset(keyword_file, attrs \\ %{}) do
    keyword_file
    |> cast(attrs, [:file])
    |> validate_required([:file])
    |> validate_file_ext()
  end

  def parse!(file_path, "text/csv") do
    file_path
    |> File.stream!()
    |> CSV.decode()
  end

  def parse!(_file_path, _unexpected_content_type) do
    raise "File with this extenstion is not supported"
  end

  defp validate_file_ext(changeset) do
    validate_change(changeset, :file, fn :file, file ->
      if Enum.member?(@accept_file_ext, Path.extname(file.filename)) do
        []
      else
        [file: "is not supported"]
      end
    end)
  end
end

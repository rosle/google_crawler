defmodule GoogleCrawler.Search.Keyword do
  use Ecto.Schema
  import Ecto.Changeset

  schema "keywords" do
    field :keyword, :string

    timestamps()
  end

  def changeset(keyword, attrs \\ %{}) do
    keyword
    |> cast(attrs, [:keyword])
    |> validate_required([:keyword])
  end
end

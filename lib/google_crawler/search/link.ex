import EctoEnum

defenum(GoogleCrawler.Search.Link.AdsPosition, top: 0, bottom: 1)

defmodule GoogleCrawler.Search.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :url, :string
    field :is_ads, :boolean, default: false
    field :ads_position, GoogleCrawler.Search.Link.AdsPosition

    belongs_to :keyword, GoogleCrawler.Search.Keyword

    timestamps()
  end

  @fields ~w(url is_ads ads_position)a

  def changeset(link, attrs \\ %{}) do
    link
    |> cast(attrs, @fields)
    |> validate_required([:url, :is_ads])
    |> validate_ads_position()
  end

  def validate_ads_position(%Ecto.Changeset{changes: %{is_ads: true}} = changeset) do
    case get_field(changeset, :ads_position) do
      nil -> add_error(changeset, :ads_position, "can't be blank")
      _ -> changeset
    end
  end

  def validate_ads_position(changeset), do: changeset
end

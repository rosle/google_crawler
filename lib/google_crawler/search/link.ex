import EctoEnum

defenum(GoogleCrawler.Search.Link.AdsPosition, top: 0, bottom: 1)

defmodule GoogleCrawler.Search.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :url, :string
    field :is_ads, :boolean
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
    validate_change(changeset, :ads_position, fn :ads_position, ads_position ->
      case ads_position do
        nil -> [ads_position: "is required"]
        _ -> []
      end
    end)
  end

  def validate_ads_position(%Ecto.Changeset{changes: %{is_ads: false}} = changeset) do
    validate_change(changeset, :ads_position, fn :ads_position, ads_position ->
      case ads_position do
        nil -> []
        _ -> [ads_position: "must be nil"]
      end
    end)
  end
end

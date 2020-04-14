import EctoEnum

defenum(GoogleCrawler.Search.Link.AdsPosition, top: 0, bottom: 1)

defmodule GoogleCrawler.Search.Link do
  use Ecto.Schema

  schema "links" do
    field :url, :string
    field :is_ads, :boolean
    field :ads_position, GoogleCrawler.Search.Link.AdsPosition

    belongs_to :keyword, GoogleCrawler.Search.Keyword
  end

  # TODO: Implement the changeset
  # import Ecto.Changeset
  # def changeset(link, attrs \\ %{}) do
  # end
end

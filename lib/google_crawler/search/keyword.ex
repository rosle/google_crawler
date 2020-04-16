import EctoEnum

defenum(GoogleCrawler.Search.Keyword.Status, in_queue: 0, in_progress: 1, failed: 2, completed: 3)

defmodule GoogleCrawler.Search.Keyword do
  use Ecto.Schema
  import Ecto.Changeset

  schema "keywords" do
    field :keyword, :string
    field :status, GoogleCrawler.Search.Keyword.Status, default: :in_queue
    field :raw_html_result, :string
    field :total_results, :integer
    field :total_ads_links, :integer
    field :total_links, :integer

    belongs_to :user, GoogleCrawler.Accounts.User
    has_many :links, GoogleCrawler.Search.Link

    timestamps()
  end

  @fields ~w(keyword user_id status raw_html_result total_results total_ads_links total_links)a

  def changeset(keyword, attrs \\ %{}) do
    keyword
    |> cast(attrs, @fields)
    |> validate_required([:keyword, :user_id, :status])
  end

  def update_result_changeset(keyword, attrs \\ %{}) do
    keyword
    |> changeset(attrs)
    |> validate_required([:raw_html_result, :total_results, :total_ads_links, :total_links])
    |> validate_number(:total_results, greater_than_or_equal_to: 0)
    |> validate_number(:total_ads_links, greater_than_or_equal_to: 0)
    |> validate_number(:total_links, greater_than_or_equal_to: 0)
  end
end

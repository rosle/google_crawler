import EctoEnum

defenum GoogleCrawler.Search.Keyword.Status,
        in_queue: 0, in_progress: 1, completed: 2

defmodule GoogleCrawler.Search.Keyword do
  use Ecto.Schema
  import Ecto.Changeset

  schema "keywords" do
    field :keyword, :string
    field :status, GoogleCrawler.Search.Keyword.Status, default: :in_queue
    field :raw_html_result, :string

    belongs_to :user, GoogleCrawler.Accounts.User

    timestamps()
  end

  def changeset(keyword, attrs \\ %{}) do
    keyword
    |> cast(attrs, [:keyword, :user_id])
    |> validate_required([:keyword, :user_id])
  end
end

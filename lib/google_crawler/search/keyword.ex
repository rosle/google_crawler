import EctoEnum

defenum(GoogleCrawler.Search.Keyword.Status, in_queue: 0, in_progress: 1, completed: 2)

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

  @fields ~w(keyword user_id status raw_html_result)a

  def changeset(keyword, attrs \\ %{}) do
    keyword
    |> cast(attrs, @fields)
    |> validate_required([:keyword, :user_id, :status])
  end
end

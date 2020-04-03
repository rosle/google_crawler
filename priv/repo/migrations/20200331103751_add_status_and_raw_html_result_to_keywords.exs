defmodule GoogleCrawler.Repo.Migrations.AddStatusAndRawHtmlResultToKeywords do
  use Ecto.Migration

  def change do
    alter table(:keywords) do
      add :status, :integer
      add :raw_html_result, :text
    end
  end
end

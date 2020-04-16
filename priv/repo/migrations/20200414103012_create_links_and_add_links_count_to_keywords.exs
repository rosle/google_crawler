defmodule GoogleCrawler.Repo.Migrations.CreateLinksAndAddLinksCountToKeyword do
  use Ecto.Migration

  def change do
    alter table(:keywords) do
      add :total_results, :bigint
      add :total_ads_links, :integer
      add :total_links, :integer
    end

    create table(:links) do
      add :url, :text
      add :is_ads, :boolean
      add :ads_position, :integer

      add :keyword_id, references(:keywords, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:links, [:keyword_id])
  end
end

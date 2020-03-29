defmodule GoogleCrawler.Repo.Migrations.CreateKeywords do
  use Ecto.Migration

  def change do
    create table(:keywords) do
      add :keyword, :string

      timestamps()
    end
  end
end

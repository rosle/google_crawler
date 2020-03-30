defmodule GoogleCrawler.Repo.Migrations.AddUserIdToKeywords do
  use Ecto.Migration

  def change do
    alter table(:keywords) do
      add :user_id, references(:users)
    end
  end
end

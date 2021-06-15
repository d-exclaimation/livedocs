defmodule Livedocs.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:document, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :body, :json

      timestamps()
    end
  end
end

defmodule Hexbear.Repo.Migrations.CreateEmbeds do
  use Ecto.Migration

  def change do
    create table(:embeds, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :description, :string
      add :html, :string
      add :title, :string
      add :thread_id, references(:threads, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:embeds, [:thread_id])
  end
end

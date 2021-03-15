defmodule Hexbear.Repo.Migrations.CreateThreads do
  use Ecto.Migration

  def change do
    create table(:threads, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string, null: false
      add :body, :string, null: true
      add :url, :string, null: true
      add :thumbnail, :string, null: true
      add :is_locked, :boolean, default: false, null: false
      add :is_unlisted, :boolean, default: false, null: false
      add :is_private, :boolean, default: false, null: false
      add :is_stickied, :boolean, default: false, null: false
      add :is_featured, :boolean, default: false, null: false
      add :creator_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :board_id, references(:boards, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:threads, [:creator_id])
    create index(:threads, [:board_id])
  end
end

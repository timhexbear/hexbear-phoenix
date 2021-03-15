defmodule Hexbear.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :path, :ltree
      add :content, :string
      add :is_locked, :boolean, default: false, null: false
      add :is_unlisted, :boolean, default: false, null: false
      add :is_private, :boolean, default: false, null: false
      add :is_stickied, :boolean, default: false, null: false
      add :creator_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :thread_id, references(:threads, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:comments, [:creator_id])
    create index(:comments, [:thread_id])
    create index(:comments, [:path], using: "GIST")
  end
end

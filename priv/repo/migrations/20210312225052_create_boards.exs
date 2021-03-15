defmodule Hexbear.Repo.Migrations.CreateBoards do
  use Ecto.Migration

  def change do
    create table(:boards, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :citext, unique: true
      add :title, :string, null: false
      add :description, :string, null: false
      add :threads_closed, :boolean, default: false, null: false
      add :comments_closed, :boolean, default: false, null: false
      add :is_private, :boolean, default: false, null: false
      add :site_id, references(:sites, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:boards, [:name], unique: true)
    create index(:boards, [:site_id])
  end
end

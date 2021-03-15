defmodule Hexbear.Repo.Migrations.CreateSites do
  use Ecto.Migration

  def change do
    create table(:sites, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string
      add :board_creation_closed, :boolean, default: false, null: false
      add :is_private, :boolean, default: false, null: false

      timestamps()
    end

  end
end

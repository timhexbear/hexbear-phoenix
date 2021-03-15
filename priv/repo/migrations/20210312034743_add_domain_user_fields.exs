defmodule Hexbear.Repo.Migrations.AddDomainUserFields do
  use Ecto.Migration

  def up do
    execute "CREATE TYPE user_status AS ENUM ('standard', 'banned', 'sitemod', 'admin');"

    alter table(:users) do
      add :name, :citext, unique: true, null: false
      add :status, :user_status, default: "standard"
    end

    create index(:users, [:name], unique: true)
  end

  def down do
    alter table(:users) do
      remove :name
      remove :status
    end
    execute "DROP TYPE user_status"
  end
end

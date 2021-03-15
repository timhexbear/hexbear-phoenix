defmodule Hexbear.Local.Site do
  use Ecto.Schema
  import Ecto.Changeset

  alias Hexbear.Local.Board

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "sites" do
    field :board_creation_closed, :boolean, default: false
    field :description, :string
    field :is_private, :boolean, default: false
    field :name, :string
    has_many :boards, Board
    has_many :threads, through: [:boards, :threads]

    timestamps()
  end

  @doc false
  def settings_changeset(site, attrs) do
    site
    |> cast(attrs, [:name, :description, :board_creation_closed, :is_private])
    |> validate_required([:name, :description, :board_creation_closed, :is_private])
  end
end

defmodule Hexbear.Local.Board do
  use Ecto.Schema
  import Ecto.Changeset

  alias Hexbear.Local.{Site, Thread}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "boards" do
    field :comments_closed, :boolean, default: false
    field :description, :string
    field :is_private, :boolean, default: false
    field :name, :string
    field :threads_closed, :boolean, default: false
    field :title, :string
    belongs_to :site, Site
    has_many :threads, Thread

    timestamps()
  end

  @doc false
  def creation_changeset(board, attrs) do
    board
    |> cast(attrs, [:name, :title, :description, :threads_closed, :comments_closed, :is_private])
    |> validate_required([:name, :title, :description, :threads_closed, :comments_closed, :is_private])
  end

  @doc false
  def settings_changeset(board, attrs) do
    board
    |> cast(attrs, [:title, :description, :threads_closed, :comments_closed, :is_private])
    |> validate_required([:title, :description, :threads_closed, :comments_closed, :is_private])
  end
end

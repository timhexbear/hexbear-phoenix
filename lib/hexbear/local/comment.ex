defmodule Hexbear.Local.Comment do
  use Ecto.Schema
  use Hierarch
  import Ecto.Changeset

  alias Hexbear.Accounts.User
  alias Hexbear.Local.Thread

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "comments" do
    field :is_locked, :boolean, default: false
    field :is_private, :boolean, default: false
    field :is_stickied, :boolean, default: false
    field :is_unlisted, :boolean, default: false
    field :path, Hierarch.Ecto.UUIDLTree, default: ""
    field :content, :string
    belongs_to :creator, User
    belongs_to :thread, Thread

    timestamps()
  end

  @doc false
  def creation_changeset(comment, attrs) do
    comment
    |> cast(attrs, [:path, :content, :creator_id, :thread_id])
    |> validate_required([:content, :creator_id, :thread_id])
  end
end

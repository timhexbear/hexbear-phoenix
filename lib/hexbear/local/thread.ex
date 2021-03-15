defmodule Hexbear.Local.Thread do
  use Ecto.Schema
  import Ecto.Changeset

  alias Hexbear.Local.{Board, Embed, Comment}
  alias Hexbear.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "threads" do
    field :body, :string
    field :is_featured, :boolean, default: false
    field :is_locked, :boolean, default: false
    field :is_private, :boolean, default: false
    field :is_stickied, :boolean, default: false
    field :is_unlisted, :boolean, default: false
    field :thumbnail, :string
    field :title, :string
    field :url, :string
    belongs_to :creator, User
    belongs_to :board, Board
    has_one :embed, Embed
    has_many :comments, Comment

    timestamps()
  end

  @doc false
  def changeset(thread, attrs) do
    thread
    |> cast(attrs, [:title, :body, :url, :thumbnail, :creator_id, :board_id])
    |> validate_required([:title, :creator_id, :board_id])
  end
end

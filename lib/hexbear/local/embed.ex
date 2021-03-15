defmodule Hexbear.Local.Embed do
  use Ecto.Schema
  import Ecto.Changeset

  alias Hexbear.Local.Thread

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "embeds" do
    field :description, :string
    field :html, :string
    field :title, :string
    belongs_to :thread, Thread

    timestamps()
  end

  @doc false
  def changeset(embed, attrs) do
    embed
    |> cast(attrs, [:description, :html, :title])
    |> validate_required([:description, :html, :title])
  end
end

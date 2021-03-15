defmodule Hexbear.Local do
  @moduledoc """
  The Local context.
  """

  import Ecto.Query, warn: false
  alias Hexbear.Repo

  alias Hexbear.Local.{Site, Board, Thread, Comment, Embed}

  @doc """
  Returns the list of sites.

  ## Examples

      iex> list_sites()
      [%Site{}, ...]

  """
  def list_sites do
    Repo.all(Site)
  end

  @doc """
  Gets a single site.

  Raises `Ecto.NoResultsError` if the Site does not exist.

  ## Examples

      iex> get_site!(123)
      %Site{}

      iex> get_site!(456)
      ** (Ecto.NoResultsError)

  """
  def get_site!(id), do: Repo.get!(Site, id)

  @doc """
  Creates a site.

  ## Examples

      iex> create_site(%{field: value})
      {:ok, %Site{}}

      iex> create_site(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_site(attrs \\ %{}) do
    %Site{}
    |> Site.settings_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a site.

  ## Examples

      iex> update_site(site, %{field: new_value})
      {:ok, %Site{}}

      iex> update_site(site, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_site(%Site{} = site, attrs) do
    site
    |> Site.settings_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a site.

  ## Examples

      iex> delete_site(site)
      {:ok, %Site{}}

      iex> delete_site(site)
      {:error, %Ecto.Changeset{}}

  """
  def delete_site(%Site{} = site) do
    Repo.delete(site)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking site changes.

  ## Examples

      iex> change_site(site)
      %Ecto.Changeset{data: %Site{}}

  """
  def change_site(%Site{} = site, attrs \\ %{}) do
    Site.settings_changeset(site, attrs)
  end

  alias Hexbear.Local.Board

  @doc """
  Returns the list of boards.

  ## Examples

      iex> list_boards()
      [%Board{}, ...]

  """
  def list_boards do
    Repo.all(Board)
  end

  @doc """
  Gets a single board.

  Raises `Ecto.NoResultsError` if the Board does not exist.

  ## Examples

      iex> get_board!(123)
      %Board{}

      iex> get_board!(456)
      ** (Ecto.NoResultsError)

  """
  def get_board!(id), do: Repo.get!(Board, id)

  def get_board_by_name!(name) do
    Board
    |> Repo.get_by!(name: name)
  end

  def get_board_with_feed!(name) do
    query = from t in Thread, order_by: [desc: t.inserted_at]

    get_board_by_name!(name)
    |> Repo.preload([threads: {query, [:creator, :board]}])
  end

  @doc """
  Creates a board.

  ## Examples

      iex> create_board(%{field: value})
      {:ok, %Board{}}

      iex> create_board(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_board(attrs \\ %{}) do
    %Board{}
    |> Board.creation_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a board.

  ## Examples

      iex> update_board(board, %{field: new_value})
      {:ok, %Board{}}

      iex> update_board(board, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_board(%Board{} = board, attrs) do
    board
    |> Board.settings_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a board.

  ## Examples

      iex> delete_board(board)
      {:ok, %Board{}}

      iex> delete_board(board)
      {:error, %Ecto.Changeset{}}

  """
  def delete_board(%Board{} = board) do
    Repo.delete(board)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking board changes.

  ## Examples

      iex> change_board(board)
      %Ecto.Changeset{data: %Board{}}

  """
  def change_board(%Board{} = board, attrs \\ %{}) do
    Board.settings_changeset(board, attrs)
  end

  alias Hexbear.Local.Thread

  @doc """
  Returns the list of threads.

  ## Examples

      iex> list_threads()
      [%Thread{}, ...]

  """
  def list_threads do
    query =
      from t in Thread,
        order_by: [desc: t.inserted_at],
        preload: [:board, :creator]
    Repo.all(query)
  end

  @doc """
  Gets a single thread.

  Raises `Ecto.NoResultsError` if the Thread does not exist.

  ## Examples

      iex> get_thread!(123)
      %Thread{}

      iex> get_thread!(456)
      ** (Ecto.NoResultsError)

  """
  def get_thread!(id), do: Repo.get!(Thread, id)

  def get_thread_with_comments!(id) do
    query =
      from c in Comment,
        order_by: [desc: c.inserted_at]

    Thread
    |> Repo.get!(id)
    |> Repo.preload([:board, :creator, comments: {query, [:creator, :thread]}])
  end

  @doc """
  Creates a thread.

  ## Examples

      iex> create_thread(%{field: value})
      {:ok, %Thread{}}

      iex> create_thread(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_thread(attrs) do
    %Thread{}
    |> Thread.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:thread_created, "all_threads")
  end
  def create_thread(attrs, room) do
    create_thread(attrs)
    |> broadcast(:thread_created, room)
  end


  @doc """
  Updates a thread.

  ## Examples

      iex> update_thread(thread, %{field: new_value})
      {:ok, %Thread{}}

      iex> update_thread(thread, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_thread(%Thread{} = thread, attrs) do
    thread
    |> Thread.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a thread.

  ## Examples

      iex> delete_thread(thread)
      {:ok, %Thread{}}

      iex> delete_thread(thread)
      {:error, %Ecto.Changeset{}}

  """
  def delete_thread(%Thread{} = thread) do
    Repo.delete(thread)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking thread changes.

  ## Examples

      iex> change_thread(thread)
      %Ecto.Changeset{data: %Thread{}}

  """
  def change_thread(%Thread{} = thread, attrs \\ %{}) do
    Thread.changeset(thread, attrs)
  end

  alias Hexbear.Local.Embed

  @doc """
  Returns the list of embeds.

  ## Examples

      iex> list_embeds()
      [%Embed{}, ...]

  """
  def list_embeds do
    Repo.all(Embed)
  end

  @doc """
  Gets a single embed.

  Raises `Ecto.NoResultsError` if the Embed does not exist.

  ## Examples

      iex> get_embed!(123)
      %Embed{}

      iex> get_embed!(456)
      ** (Ecto.NoResultsError)

  """
  def get_embed!(id), do: Repo.get!(Embed, id)

  @doc """
  Creates a embed.

  ## Examples

      iex> create_embed(%{field: value})
      {:ok, %Embed{}}

      iex> create_embed(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_embed(attrs \\ %{}) do
    %Embed{}
    |> Embed.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a embed.

  ## Examples

      iex> update_embed(embed, %{field: new_value})
      {:ok, %Embed{}}

      iex> update_embed(embed, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_embed(%Embed{} = embed, attrs) do
    embed
    |> Embed.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a embed.

  ## Examples

      iex> delete_embed(embed)
      {:ok, %Embed{}}

      iex> delete_embed(embed)
      {:error, %Ecto.Changeset{}}

  """
  def delete_embed(%Embed{} = embed) do
    Repo.delete(embed)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking embed changes.

  ## Examples

      iex> change_embed(embed)
      %Ecto.Changeset{data: %Embed{}}

  """
  def change_embed(%Embed{} = embed, attrs \\ %{}) do
    Embed.changeset(embed, attrs)
  end

  alias Hexbear.Local.Comment

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments do
    Repo.all(Comment)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}, room) do
    IO.inspect("Creating a comment in room:")
    IO.inspect(room)
    %Comment{}
    |> Comment.creation_changeset(attrs)
    |> Repo.insert()
    |> broadcast(:comment_created, room)
  end

  def create_child_comment(parent, attrs \\ %{}, room) do
    IO.inspect("Creating a comment in room:")
    IO.inspect(room)
    parent
    |> Comment.build_child_of(attrs)
    |> Repo.insert()
    |> broadcast(:comment_created, room)
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.creation_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.creation_changeset(comment, attrs)
  end

  def subscribe(room) do
    IO.inspect("New subscription in room:")
    IO.inspect(room)
    Phoenix.PubSub.subscribe(Hexbear.PubSub, room)
  end

  defp broadcast({:error, _reason} = error, _event, _room), do: error
  defp broadcast({:ok, post}, event, room) do
    Phoenix.PubSub.broadcast(Hexbear.PubSub, room, {event, post})
    {:ok, post}
  end
end

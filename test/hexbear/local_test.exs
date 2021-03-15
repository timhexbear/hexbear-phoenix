defmodule Hexbear.LocalTest do
  use Hexbear.DataCase

  alias Hexbear.Local

  describe "sites" do
    alias Hexbear.Local.Site

    @valid_attrs %{board_creation_closed: true, description: "some description", is_private: true, name: "some name"}
    @update_attrs %{board_creation_closed: false, description: "some updated description", is_private: false, name: "some updated name"}
    @invalid_attrs %{board_creation_closed: nil, description: nil, is_private: nil, name: nil}

    def site_fixture(attrs \\ %{}) do
      {:ok, site} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Local.create_site()

      site
    end

    test "list_sites/0 returns all sites" do
      site = site_fixture()
      assert Local.list_sites() == [site]
    end

    test "get_site!/1 returns the site with given id" do
      site = site_fixture()
      assert Local.get_site!(site.id) == site
    end

    test "create_site/1 with valid data creates a site" do
      assert {:ok, %Site{} = site} = Local.create_site(@valid_attrs)
      assert site.board_creation_closed == true
      assert site.description == "some description"
      assert site.is_private == true
      assert site.name == "some name"
    end

    test "create_site/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Local.create_site(@invalid_attrs)
    end

    test "update_site/2 with valid data updates the site" do
      site = site_fixture()
      assert {:ok, %Site{} = site} = Local.update_site(site, @update_attrs)
      assert site.board_creation_closed == false
      assert site.description == "some updated description"
      assert site.is_private == false
      assert site.name == "some updated name"
    end

    test "update_site/2 with invalid data returns error changeset" do
      site = site_fixture()
      assert {:error, %Ecto.Changeset{}} = Local.update_site(site, @invalid_attrs)
      assert site == Local.get_site!(site.id)
    end

    test "delete_site/1 deletes the site" do
      site = site_fixture()
      assert {:ok, %Site{}} = Local.delete_site(site)
      assert_raise Ecto.NoResultsError, fn -> Local.get_site!(site.id) end
    end

    test "change_site/1 returns a site changeset" do
      site = site_fixture()
      assert %Ecto.Changeset{} = Local.change_site(site)
    end
  end

  describe "boards" do
    alias Hexbear.Local.Board

    @valid_attrs %{comments_closed: true, description: "some description", is_private: true, name: "some name", threads_closed: true, title: "some title"}
    @update_attrs %{comments_closed: false, description: "some updated description", is_private: false, name: "some updated name", threads_closed: false, title: "some updated title"}
    @invalid_attrs %{comments_closed: nil, description: nil, is_private: nil, name: nil, threads_closed: nil, title: nil}

    def board_fixture(attrs \\ %{}) do
      {:ok, board} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Local.create_board()

      board
    end

    test "list_boards/0 returns all boards" do
      board = board_fixture()
      assert Local.list_boards() == [board]
    end

    test "get_board!/1 returns the board with given id" do
      board = board_fixture()
      assert Local.get_board!(board.id) == board
    end

    test "create_board/1 with valid data creates a board" do
      assert {:ok, %Board{} = board} = Local.create_board(@valid_attrs)
      assert board.comments_closed == true
      assert board.description == "some description"
      assert board.is_private == true
      assert board.name == "some name"
      assert board.threads_closed == true
      assert board.title == "some title"
    end

    test "create_board/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Local.create_board(@invalid_attrs)
    end

    test "update_board/2 with valid data updates the board" do
      board = board_fixture()
      assert {:ok, %Board{} = board} = Local.update_board(board, @update_attrs)
      assert board.comments_closed == false
      assert board.description == "some updated description"
      assert board.is_private == false
      assert board.name == "some updated name"
      assert board.threads_closed == false
      assert board.title == "some updated title"
    end

    test "update_board/2 with invalid data returns error changeset" do
      board = board_fixture()
      assert {:error, %Ecto.Changeset{}} = Local.update_board(board, @invalid_attrs)
      assert board == Local.get_board!(board.id)
    end

    test "delete_board/1 deletes the board" do
      board = board_fixture()
      assert {:ok, %Board{}} = Local.delete_board(board)
      assert_raise Ecto.NoResultsError, fn -> Local.get_board!(board.id) end
    end

    test "change_board/1 returns a board changeset" do
      board = board_fixture()
      assert %Ecto.Changeset{} = Local.change_board(board)
    end
  end

  describe "threads" do
    alias Hexbear.Local.Thread

    @valid_attrs %{body: "some body", is_featured: true, is_locked: true, is_private: true, is_stickied: true, is_unlisted: true, thumbnail: "some thumbnail", title: "some title", url: "some url"}
    @update_attrs %{body: "some updated body", is_featured: false, is_locked: false, is_private: false, is_stickied: false, is_unlisted: false, thumbnail: "some updated thumbnail", title: "some updated title", url: "some updated url"}
    @invalid_attrs %{body: nil, is_featured: nil, is_locked: nil, is_private: nil, is_stickied: nil, is_unlisted: nil, thumbnail: nil, title: nil, url: nil}

    def thread_fixture(attrs \\ %{}) do
      {:ok, thread} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Local.create_thread()

      thread
    end

    test "list_threads/0 returns all threads" do
      thread = thread_fixture()
      assert Local.list_threads() == [thread]
    end

    test "get_thread!/1 returns the thread with given id" do
      thread = thread_fixture()
      assert Local.get_thread!(thread.id) == thread
    end

    test "create_thread/1 with valid data creates a thread" do
      assert {:ok, %Thread{} = thread} = Local.create_thread(@valid_attrs)
      assert thread.body == "some body"
      assert thread.is_featured == true
      assert thread.is_locked == true
      assert thread.is_private == true
      assert thread.is_stickied == true
      assert thread.is_unlisted == true
      assert thread.thumbnail == "some thumbnail"
      assert thread.title == "some title"
      assert thread.url == "some url"
    end

    test "create_thread/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Local.create_thread(@invalid_attrs)
    end

    test "update_thread/2 with valid data updates the thread" do
      thread = thread_fixture()
      assert {:ok, %Thread{} = thread} = Local.update_thread(thread, @update_attrs)
      assert thread.body == "some updated body"
      assert thread.is_featured == false
      assert thread.is_locked == false
      assert thread.is_private == false
      assert thread.is_stickied == false
      assert thread.is_unlisted == false
      assert thread.thumbnail == "some updated thumbnail"
      assert thread.title == "some updated title"
      assert thread.url == "some updated url"
    end

    test "update_thread/2 with invalid data returns error changeset" do
      thread = thread_fixture()
      assert {:error, %Ecto.Changeset{}} = Local.update_thread(thread, @invalid_attrs)
      assert thread == Local.get_thread!(thread.id)
    end

    test "delete_thread/1 deletes the thread" do
      thread = thread_fixture()
      assert {:ok, %Thread{}} = Local.delete_thread(thread)
      assert_raise Ecto.NoResultsError, fn -> Local.get_thread!(thread.id) end
    end

    test "change_thread/1 returns a thread changeset" do
      thread = thread_fixture()
      assert %Ecto.Changeset{} = Local.change_thread(thread)
    end
  end

  describe "embeds" do
    alias Hexbear.Local.Embed

    @valid_attrs %{description: "some description", html: "some html", title: "some title"}
    @update_attrs %{description: "some updated description", html: "some updated html", title: "some updated title"}
    @invalid_attrs %{description: nil, html: nil, title: nil}

    def embed_fixture(attrs \\ %{}) do
      {:ok, embed} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Local.create_embed()

      embed
    end

    test "list_embeds/0 returns all embeds" do
      embed = embed_fixture()
      assert Local.list_embeds() == [embed]
    end

    test "get_embed!/1 returns the embed with given id" do
      embed = embed_fixture()
      assert Local.get_embed!(embed.id) == embed
    end

    test "create_embed/1 with valid data creates a embed" do
      assert {:ok, %Embed{} = embed} = Local.create_embed(@valid_attrs)
      assert embed.description == "some description"
      assert embed.html == "some html"
      assert embed.title == "some title"
    end

    test "create_embed/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Local.create_embed(@invalid_attrs)
    end

    test "update_embed/2 with valid data updates the embed" do
      embed = embed_fixture()
      assert {:ok, %Embed{} = embed} = Local.update_embed(embed, @update_attrs)
      assert embed.description == "some updated description"
      assert embed.html == "some updated html"
      assert embed.title == "some updated title"
    end

    test "update_embed/2 with invalid data returns error changeset" do
      embed = embed_fixture()
      assert {:error, %Ecto.Changeset{}} = Local.update_embed(embed, @invalid_attrs)
      assert embed == Local.get_embed!(embed.id)
    end

    test "delete_embed/1 deletes the embed" do
      embed = embed_fixture()
      assert {:ok, %Embed{}} = Local.delete_embed(embed)
      assert_raise Ecto.NoResultsError, fn -> Local.get_embed!(embed.id) end
    end

    test "change_embed/1 returns a embed changeset" do
      embed = embed_fixture()
      assert %Ecto.Changeset{} = Local.change_embed(embed)
    end
  end

  describe "comments" do
    alias Hexbear.Local.Comment

    @valid_attrs %{is_locked: true, is_private: true, is_stickied: true, is_unlisted: true, path: "some path"}
    @update_attrs %{is_locked: false, is_private: false, is_stickied: false, is_unlisted: false, path: "some updated path"}
    @invalid_attrs %{is_locked: nil, is_private: nil, is_stickied: nil, is_unlisted: nil, path: nil}

    def comment_fixture(attrs \\ %{}) do
      {:ok, comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Local.create_comment()

      comment
    end

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Local.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Local.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      assert {:ok, %Comment{} = comment} = Local.create_comment(@valid_attrs)
      assert comment.is_locked == true
      assert comment.is_private == true
      assert comment.is_stickied == true
      assert comment.is_unlisted == true
      assert comment.path == "some path"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Local.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{} = comment} = Local.update_comment(comment, @update_attrs)
      assert comment.is_locked == false
      assert comment.is_private == false
      assert comment.is_stickied == false
      assert comment.is_unlisted == false
      assert comment.path == "some updated path"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Local.update_comment(comment, @invalid_attrs)
      assert comment == Local.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Local.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Local.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Local.change_comment(comment)
    end
  end
end

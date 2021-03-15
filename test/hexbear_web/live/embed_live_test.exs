defmodule HexbearWeb.EmbedLiveTest do
  use HexbearWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Hexbear.Local

  @create_attrs %{description: "some description", html: "some html", title: "some title"}
  @update_attrs %{description: "some updated description", html: "some updated html", title: "some updated title"}
  @invalid_attrs %{description: nil, html: nil, title: nil}

  defp fixture(:embed) do
    {:ok, embed} = Local.create_embed(@create_attrs)
    embed
  end

  defp create_embed(_) do
    embed = fixture(:embed)
    %{embed: embed}
  end

  describe "Index" do
    setup [:create_embed]

    test "lists all embeds", %{conn: conn, embed: embed} do
      {:ok, _index_live, html} = live(conn, Routes.embed_index_path(conn, :index))

      assert html =~ "Listing Embeds"
      assert html =~ embed.description
    end

    test "saves new embed", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.embed_index_path(conn, :index))

      assert index_live |> element("a", "New Embed") |> render_click() =~
               "New Embed"

      assert_patch(index_live, Routes.embed_index_path(conn, :new))

      assert index_live
             |> form("#embed-form", embed: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#embed-form", embed: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.embed_index_path(conn, :index))

      assert html =~ "Embed created successfully"
      assert html =~ "some description"
    end

    test "updates embed in listing", %{conn: conn, embed: embed} do
      {:ok, index_live, _html} = live(conn, Routes.embed_index_path(conn, :index))

      assert index_live |> element("#embed-#{embed.id} a", "Edit") |> render_click() =~
               "Edit Embed"

      assert_patch(index_live, Routes.embed_index_path(conn, :edit, embed))

      assert index_live
             |> form("#embed-form", embed: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#embed-form", embed: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.embed_index_path(conn, :index))

      assert html =~ "Embed updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes embed in listing", %{conn: conn, embed: embed} do
      {:ok, index_live, _html} = live(conn, Routes.embed_index_path(conn, :index))

      assert index_live |> element("#embed-#{embed.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#embed-#{embed.id}")
    end
  end

  describe "Show" do
    setup [:create_embed]

    test "displays embed", %{conn: conn, embed: embed} do
      {:ok, _show_live, html} = live(conn, Routes.embed_show_path(conn, :show, embed))

      assert html =~ "Show Embed"
      assert html =~ embed.description
    end

    test "updates embed within modal", %{conn: conn, embed: embed} do
      {:ok, show_live, _html} = live(conn, Routes.embed_show_path(conn, :show, embed))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Embed"

      assert_patch(show_live, Routes.embed_show_path(conn, :edit, embed))

      assert show_live
             |> form("#embed-form", embed: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#embed-form", embed: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.embed_show_path(conn, :show, embed))

      assert html =~ "Embed updated successfully"
      assert html =~ "some updated description"
    end
  end
end

defmodule HexbearWeb.BoardLive.Index do
  use HexbearWeb, :live_view

  alias Hexbear.Local
  alias Hexbear.Local.Board

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :boards, list_boards())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Board")
    |> assign(:board, Local.get_board!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Board")
    |> assign(:board, %Board{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Boards")
    |> assign(:board, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    board = Local.get_board!(id)
    {:ok, _} = Local.delete_board(board)

    {:noreply, assign(socket, :boards, list_boards())}
  end

  defp list_boards do
    Local.list_boards()
  end
end

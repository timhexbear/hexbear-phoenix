defmodule HexbearWeb.BoardLive.Show do
  use HexbearWeb, :live_view

  alias Hexbear.Local

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"name" => name}, _, socket) do
    board = Local.get_board_with_feed!(name)
    threads = board.threads

    if connected?(socket) do
      Local.subscribe(board.id)
    end

    {:noreply,
     socket
     |> assign(:page_title, name)
     |> assign(:board, board)
     |> assign(:threads, threads)
    }
  end

  @impl true
  def handle_info({:thread_created, thread}, socket) do
    {:noreply,
     socket
     |> update(:threads, fn threads -> [thread | threads] end)
    }
  end
end

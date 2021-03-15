defmodule HexbearWeb.BoardLive.Create do
  use HexbearWeb, :live_view

  alias Hexbear.Local
  alias Hexbear.Local.Board

  @impl true
  def mount(_params, _session, socket) do
    changeset = Local.change_board(%Board{}, %{})

    {:ok,
     socket
     |> assign(:changeset, changeset)
    }
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"board" => board_params}, socket) do
    changeset =
      %Board{}
      |> Local.change_board(board_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"board" => board_params}, socket) do
    case Local.create_board(board_params) do
      {:ok, board} ->
        {:noreply,
         socket
         |> put_flash(:info, "Board created successfully")
         |> push_redirect(to: ~s"/b/#{board.name}")
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)
      }
    end
  end
end

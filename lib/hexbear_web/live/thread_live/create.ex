defmodule HexbearWeb.ThreadLive.Create do
  use HexbearWeb, :live_view

  alias Hexbear.Local
  alias Hexbear.Local.Thread
  alias Hexbear.Accounts

  @impl true
  def mount(params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    current_board = Local.get_board_by_name!(params["name"])
    changeset = Local.change_thread(
      %Thread{},
      %{board_id: current_board.id, creator_id: current_user.id}
    )

    {:ok,
     socket
     |> assign(:board_id, current_board.id)
     |> assign(:creator_id, current_user.id)
     |> assign(:changeset, changeset)
     |> assign(:page_title, params["name"])
    }
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"thread" => thread_params}, socket) do
    changeset =
      %Thread{}
      |> Local.change_thread(thread_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"thread" => thread_params}, socket) do
    case Local.create_thread(thread_params, socket.assigns.board_id) do
      {:ok, thread} ->
        {:noreply,
         socket
         |> put_flash(:info, "Thread created successfully")
         |> push_redirect(to: Routes.thread_show_path(socket, :show, thread))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

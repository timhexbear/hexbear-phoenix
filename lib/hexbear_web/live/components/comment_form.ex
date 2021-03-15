defmodule HexbearWeb.Components.CommentForm do
  use HexbearWeb, :live_component

  alias Hexbear.Local

  @impl true
  def update(
      %{
        id: _thread_id,
        user_id: _user_id,
        parent: _parent,
        comment: comment
      } = assigns,
      socket
    ) do
    changeset = Local.change_comment(comment)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
    }
  end

  @impl true
  def handle_event("validate", %{"comment" => comment_params}, socket) do
    changeset =
      socket.assigns.comment
      |> Local.change_comment(comment_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"comment" => comment_params}, socket) do
    result = case socket.assigns.parent do
      nil ->
        IO.inspect("Comment created in room:")
        IO.inspect(socket.assigns.id)
        Local.create_comment(comment_params, socket.assigns.id)

      parent ->
        IO.inspect("Comment created in room:")
        IO.inspect(socket.assigns.id)
        Local.create_child_comment(parent, comment_params, socket.assigns.id)
    end

    case result do
      {:ok, _comment} ->
        {:noreply,
         socket
         |> assign(:changeset, Local.change_comment(socket.assigns.comment))
         |> put_flash(:info, "Comment created successfully")
         #|> push_redirect(to: socket.assigns.return_to)
      }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

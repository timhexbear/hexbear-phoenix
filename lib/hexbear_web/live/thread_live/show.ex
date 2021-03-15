defmodule HexbearWeb.ThreadLive.Show do
  use HexbearWeb, :live_view

  alias Hexbear.Local
  alias Hexbear.Accounts

  @impl true
  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:current_user_id, current_user.id)
    }
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    thread = Local.get_thread_with_comments!(id)
    comments = thread.comments

    if connected?(socket) do
      Local.subscribe(thread.id)
    end

    {:noreply,
     socket
     |> assign(:page_title, thread.title)
     |> assign(:thread, thread)
     |> assign(:comments, comments)
    }
  end

  @impl true
  def handle_info({:comment_created, comment}, socket) do
    {:noreply,
     socket
     |> update(:comments, fn comments -> [comment | comments] end)
    }
  end
end

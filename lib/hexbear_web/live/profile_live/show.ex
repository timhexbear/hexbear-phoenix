defmodule HexbearWeb.ProfileLive.Show do
  use HexbearWeb, :live_view

  alias Hexbear.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"name" => name}, _, socket) do
    user = Accounts.get_user_profile_by_name!(name)
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:user, user)
    }
  end

  def render_status_change_buttons(assigns, :standard) do
    ~L"""
    <button phx-click="siteban_user">Ban From Site</button>
    <button phx-click="sitemod_user">Make Sitemod</button>
    <button phx-click="admin_user">Make Admin</button>
    """
  end
  def render_status_change_buttons(assigns, :banned) do
    ~L"""
    <button phx-click="standard_user">Unban From Site</button>
    """
  end
  def render_status_change_buttons(assigns, :sitemod) do
    ~L"""
    <button phx-click="standard_user">Revoke Sitemod Privileges</button>
    <button phx-click="admin_user">Make Admin</button>
    """
  end
  def render_status_change_buttons(assigns, :admin) do
    ~L"""
    <button phx-click="standard_user">Revoke Admin Privileges</button>
    """
  end

  @impl true
  def handle_event("siteban_user", _, socket) do
    user = Accounts.user_become_sitebanned(socket.assigns.user)
    socket = assign(socket, :user, user)
    {:noreply, socket}
  end

  def handle_event("standard_user", _, socket) do
    user = Accounts.user_become_standard(socket.assigns.user)
    socket = assign(socket, :user, user)
    {:noreply, socket}
  end

  def handle_event("sitemod_user", _, socket) do
    user = Accounts.user_become_sitemod(socket.assigns.user)
    socket = assign(socket, :user, user)
    {:noreply, socket}
  end

  def handle_event("admin_user", _, socket) do
    user = Accounts.user_become_admin(socket.assigns.user)
    socket = assign(socket, :user, user)
    {:noreply, socket}
  end

  defp page_title(:show), do: "Show User"
end

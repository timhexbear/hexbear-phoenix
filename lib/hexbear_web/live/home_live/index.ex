defmodule HexbearWeb.HomeLive.Index do
  use HexbearWeb, :live_view

  alias Hexbear.Local

  @impl true
    def mount(_params, _session, socket) do
    if connected?(socket) do
      Local.subscribe("all_threads")
    end
    threads = Local.list_threads()

    {:ok,
     socket
     |> assign(threads: threads)
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

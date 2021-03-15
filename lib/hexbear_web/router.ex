defmodule HexbearWeb.Router do
  use HexbearWeb, :router

  import HexbearWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {HexbearWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  ## Authentication routes

  scope "/", HexbearWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/register", UserRegistrationController, :new
    post "/register", UserRegistrationController, :create
    get "/log_in", UserSessionController, :new
    post "/log_in", UserSessionController, :create
    get "/reset_password", UserResetPasswordController, :new
    post "/reset_password", UserResetPasswordController, :create
    get "/reset_password/:token", UserResetPasswordController, :edit
    put "/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", HexbearWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/create_board", BoardLive.Create, :new
    live "/b/:name/create_thread", ThreadLive.Create, :new

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", HexbearWeb do
    pipe_through [:browser]

    live "/", HomeLive.Index, :index

    live "/u/:name", ProfileLive.Show, :show

    live "/b/:name", BoardLive.Show, :show
    live "/boards", BoardLive.Index, :index
    live "/thread/:id", ThreadLive.Show, :show

    delete "/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end
end

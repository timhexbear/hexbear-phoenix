defmodule Hexbear.Repo do
  use Ecto.Repo,
    otp_app: :hexbear,
    adapter: Ecto.Adapters.Postgres
end

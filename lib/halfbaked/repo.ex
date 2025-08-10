defmodule Halfbaked.Repo do
  use Ecto.Repo,
    otp_app: :halfbaked,
    adapter: Ecto.Adapters.Postgres
end

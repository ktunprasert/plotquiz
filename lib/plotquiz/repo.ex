defmodule Plotquiz.Repo do
  use Ecto.Repo,
    otp_app: :plotquiz,
    adapter: Ecto.Adapters.SQLite3
end

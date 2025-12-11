defmodule ReleasePlayground.Repo do
  use Ecto.Repo,
    otp_app: :release_playground,
    adapter: Ecto.Adapters.Postgres
end

defmodule ReleasePlaygroundWeb.PageController do
  use ReleasePlaygroundWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end

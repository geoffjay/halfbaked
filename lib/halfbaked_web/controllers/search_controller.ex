defmodule HalfbakedWeb.SearchController do
  use HalfbakedWeb, :controller

  alias Halfbaked.Ideas

  def index(conn, params) do
    q = Map.get(params, "q", "")
    results = if q == "", do: %{ideas: [], plans: [], tasks: [], documents: []}, else: Ideas.search(q, conn.assigns[:current_user])
    render(conn, :index, q: q, results: results)
  end
end

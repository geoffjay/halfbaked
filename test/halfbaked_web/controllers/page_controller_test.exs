defmodule HalfbakedWeb.PageControllerTest do
  use HalfbakedWeb.ConnCase

  test "GET / redirects to ideas", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert redirected_to(conn) == ~p"/ideas"
  end
end

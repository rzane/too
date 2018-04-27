defmodule Too.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Too.Router

  defp call(verb, path, params_or_body \\ nil) do
    verb
    |> conn(path, params_or_body)
    |> Router.call(Router.init([]))
  end

  test "it pushes" do
    conn = call(:get, "/")

    asset = "/assets/index.css"
    headers = [{"accept", "text/css"}]

    assert sent_pushes(conn) == [{asset, headers}]
  end
end

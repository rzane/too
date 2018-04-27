defmodule Too.Router do
  use Plug.Router

  plug(Plug.Logger)
  plug(Plug.Static, at: "/assets", from: {:too, "priv/assets"})
  plug(:match)
  plug(:dispatch)

  get "/" do
    index =
      :too
      |> Application.app_dir()
      |> Path.join("priv/assets/index.html")

    conn
    |> put_resp_content_type("text/html")
    |> push!("/assets/index.css")
    |> send_file(200, index)
  end

  get "/check" do
    case conn.adapter do
      {_, %{version: :"HTTP/2"}} ->
        send_resp(conn, 200, "<h1 style=\"color: green\">You are using HTTP/2!</h1>")

      _ ->
        send_resp(conn, 200, "<h1 style=\"color: red\">You are not using HTTP/2!</h1>")
    end
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end

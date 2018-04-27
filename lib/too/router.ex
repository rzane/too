defmodule Too.Router do
  use Plug.Router

  plug(Plug.Logger, log: :debug)
  plug(Plug.Static, at: "/assets", from: {:too, "priv/assets"})
  plug(:match)
  plug(:dispatch)

  get "/" do
    file =
      :too
      |> Application.app_dir()
      |> Path.join("priv/assets/index.html")

    conn
    |> push("/assets/index.js", accept: "application/javascript")
    |> push("/assets/index.css", accept: "text/css")
    |> put_resp_content_type("text/html")
    |> send_file(200, file)
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

defmodule Too.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @https_options [
    port: 4444,
    certfile: Path.join(Application.app_dir(:too), "priv/server.pem"),
    keyfile: Path.join(Application.app_dir(:too), "priv/server.key")
  ]

  @http2_options [
    cacertfile: @https_options[:certfile],
    server_name_indication: 'localhost'
  ]

  setup_all do
    {:ok, _} = Application.ensure_all_started(:kadabra)
    {:ok, _pid} = Plug.Adapters.Cowboy2.https(Too.Router, [], @https_options)
    :ok
  end

  test "it pushes" do
    {:ok, pid} = Kadabra.open("https://localhost:4444", ssl: @http2_options)

    Kadabra.get(pid, "/")
    assert_receive({:push_promise, %Kadabra.Stream.Response{headers: script}})
    assert_receive({:push_promise, %Kadabra.Stream.Response{headers: styles}})

    assert_receive({:end_stream, %Kadabra.Stream.Response{} = one})
    assert_receive({:end_stream, %Kadabra.Stream.Response{} = two})
    assert_receive({:end_stream, %Kadabra.Stream.Response{} = three})

    assert {":path", "/assets/index.js"} in script
    assert {"accept", "application/javascript"} in script

    assert {":path", "/assets/index.css"} in styles
    assert {"accept", "text/css"} in styles

    IO.inspect([one, two, thre])
  end
end

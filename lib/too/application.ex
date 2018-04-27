defmodule Too.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    certfile = priv_file("server.pem")
    keyfile = priv_file("server.key")

    unless File.exists?(keyfile) do
      raise """
      No SSL key/cert found. Please run the following command:

        openssl req -new -newkey rsa:4096 -days 365 -nodes -x509  \
        -subj "/CN=localhost" \
        -keyout priv/server.key -out priv/server.pem
      """
    end

    # List all child processes to be supervised
    children = [
      {Plug.Adapters.Cowboy2,
       scheme: :https,
       plug: Too.Router,
       options: [port: 4000, certfile: certfile, keyfile: keyfile]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Too.Supervisor]

    IO.puts("Starting server at https://localhost:4000")

    Supervisor.start_link(children, opts)
  end

  defp priv_file(name) do
    :too
    |> Application.app_dir()
    |> Path.join("priv")
    |> Path.join(name)
  end
end

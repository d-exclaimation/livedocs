defmodule Livedocs do
  @moduledoc """
  Documentation for `Livedocs`.
  """

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    IO.puts("\n")

    children = [
      Livedocs.Repo,
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Livedocs.Router,
        options: [
          dispatch: dispatch(),
          port: String.to_integer(System.get_env("PORT", "4000"))
        ]
      ),
      Registry.child_spec(
        keys: :duplicate,
        name: Registry.Livedocs
      )
    ]

    opts = [strategy: :one_for_one, name: Livedocs.Application]
    Supervisor.start_link(children, opts)
  end

  @spec dispatch() :: [{:_, [{String.t() | atom, atom, [any]}]}]
  defp dispatch() do
    [
      {:_,
       [
         {"/ws/[...]", Livedocs.Socket, []},
         {:_, Plug.Cowboy.Handler, {Livedocs.Router, []}}
       ]}
    ]
  end
end

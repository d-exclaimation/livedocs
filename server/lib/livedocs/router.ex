#
#  router.ex
#  livedocs
#
#  Created by d-exclaimation on 18:09.
#

defmodule Livedocs.Router do
  @moduledoc """
   Routing
  """
  use Plug.Router
  alias Livedocs.{Document, Mutations}

  plug(CORSPlug,
    origin: ["http://localhost:3000", "http://example2.com", ~r/https?.*example\d?\.com$/],
    methods: ["GET", "PUT"]
  )

  # Match routes
  plug(:match)

  # Plug anything with the header of application/json to be parse using Jason
  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  post "/" do
    with attr <- Mutations.create_attr(%{}),
         {:ok, doc} <- Mutations.create(attr) do
      conn
      |> send_resp(200, Jason.encode!(%{id: doc.id}))
    else
      _ -> conn |> send_resp(500, "Lol")
    end
  end

  put "/" do
    with %{"data" => data, "id" => raw_id} <- conn.params,
         {:ok, id} <- Ecto.UUID.cast(raw_id),
         changes <- Mutations.create_attr(data),
         {:ok, %Document{} = doc} <- Mutations.update(id, changes) do
      conn
      |> send_resp(200, "#{doc.id == id}")
    else
      _ -> conn |> send_resp(400, "Wrong stuff")
    end
  end

  # Anything else is a 404 not found request
  match _ do
    conn
    |> send_resp(404, "404 Not found")
  end
end

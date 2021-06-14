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

  plug(CORSPlug,
    origin: ["http://localhost:3000", "http://example2.com", ~r/https?.*example\d?\.com$/]
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

  # Get request of path /, response a test message
  get "/" do
    conn
    |> send_resp(200, "Hello World")
  end

  # Anything else is a 404 not found request
  match _ do
    conn
    |> send_resp(404, "404 Not found")
  end
end

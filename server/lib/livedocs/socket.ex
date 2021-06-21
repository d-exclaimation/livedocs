#
#  socket.ex
#  livedocs
#
#  Created by d-exclaimation on 18:14.
#

defmodule Livedocs.Socket do
  @moduledoc """
    Socket Handler
  """
  @behaviour :cowboy_websocket
  alias Livedocs.{Queries, Document}

  @type state :: %{registry_key: any()}
  @type response :: {:ok, state()} | {:reply, {:text, binary()}, state()}

  def init(request, _state) do
    "/ws/" <> id = request.path
    # Get the state as the registry key of the request path
    state = %{registry_key: id}

    IO.puts("Connection was made on #{id}")
    {:cowboy_websocket, request, state}
  end

  @spec websocket_init(state()) :: response()
  def websocket_init(state) do
    with {:ok, uuid} <- Ecto.UUID.cast(state.registry_key),
         %Document{} = doc <- Queries.get_by_id(uuid) do
      # Put in the key and value of an pid, client tuple into a registry
      Registry.Livedocs
      |> Registry.register(state.registry_key, {})

      {:reply, {:text, Jason.encode!(%{type: "init", payload: doc.body})}, state}
    else
      _ -> {:stop, state}
    end
  end

  @doc """
  Incoming text response
  """
  @spec websocket_handle({:text, any()}, state()) :: response()
  def websocket_handle({:text, json}, state) do
    # Parse data, and encode them back lol
    with {:ok, %{"data" => data}} <- Jason.decode(json),
         {:ok, message} <- Jason.encode(%{payload: data, type: "operations"}) do
      # Emit to all
      emit(state.registry_key, message)
      {:ok, state}
    else
      _ -> {:reply}
    end
  end

  @doc """
  Check for websocket passed by the other clients
  """
  @spec websocket_info(String.t(), state()) :: response()
  def websocket_info(message, state) do
    {:reply, {:text, message}, state}
  end

  @doc """
  Emit to all client from registry
  """
  @spec emit(binary(), binary()) :: :ok
  def emit(key, message) do
    Registry.Livedocs
    |> Registry.dispatch(key, &do_emit(&1, message))
  end

  @spec do_emit({pid(), any()}, binary()) :: [:ok]
  defp do_emit(entries, message) do
    for {pid, _} <- entries, pid != self(), do: Process.send(pid, message, [])
  end
end

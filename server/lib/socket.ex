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

  @type state :: %{registry_key: any()}

  def init(request, _state) do
    # Get the state as the registry key of the request path
    state = %{registry_key: request.path}

    IO.puts("Connection was made on #{request.path}")
    {:cowboy_websocket, request, state}
  end

  @spec websocket_init(state()) :: {:ok, state()}
  def websocket_init(state) do
    # Put in the key and value of an pid, client tuple into a registry
    Registry.Livedocs
    |> Registry.register(state.registry_key, {})

    # TODO: Should send the data initial state
    {:ok, state}
  end

  @doc """
  Incoming text response
  """
  @spec websocket_handle({:text, any()}, state()) :: {:ok, state()}
  def websocket_handle({:text, json}, state) do
    # Parse data, and encode them back lol
    with {:ok, %{"data" => data}} <- Jason.decode(json),
         {:ok, message} <- Jason.encode(data) do
      # Emit to all
      emit(state.registry_key, message)

      # TODO: Update to add endpoint for saving or using post request lol

      {:ok, state}
    else
      _ -> {:reply}
    end
  end

  @doc """
  Check for websocket passed by the other clients
  """
  @spec websocket_info(String.t(), state()) :: {:reply, {:text, String.t()}, state()}
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

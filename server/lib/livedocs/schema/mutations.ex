#
#  mutations.ex
#  livedocs
#
#  Created by d-exclaimation on 11:08.
#

defmodule Livedocs.Mutations do
  @moduledoc """
  Document mutations
  """
  alias Livedocs.{Document, Repo}

  @doc """
  Assign the correct field to the attributes
  """
  @spec create_attr(map()) :: map()
  def create_attr(delta) do
    %{"body" => delta}
  end

  @doc """
  Create a new document using Document Changeset
  """
  @spec create(map()) :: {:ok, Document.t()} | {:error, Ecto.Changeset.t()}
  def create(doc_attr) do
    %Document{}
    |> Document.changeset(doc_attr)
    |> Repo.insert()
  end

  @doc """
  Update a document informations
  """
  @spec update(Ecto.UUID.t(), map()) ::
          {:ok, Document.t()} | {:error, Ecto.Changeset.t()}
  def update(id, changes) do
    res =
      Document
      |> Repo.get(id)

    case res do
      %Document{} = doc ->
        doc
        |> Document.changeset(changes)
        |> Repo.update()

      _ ->
        {:error, %Ecto.Changeset{data: nil, errors: [{:user_id, "invalid id"}]}}
    end
  end
end

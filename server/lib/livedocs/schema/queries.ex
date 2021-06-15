#
#  queries.ex
#  livedocs
#
#  Created by d-exclaimation on 12:07.
#

defmodule Livedocs.Queries do
  @moduledoc """
  Queries on Document
  """
  alias Livedocs.{Document, Repo}

  @doc """
  Get single document
  """
  @spec getById(Ecto.UUID.t()) :: Document.t() | none()
  def getById(id) do
    Document
    |> Repo.get(id)
  end
end

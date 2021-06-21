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
  @spec get_by_id(Ecto.UUID.t()) :: Document.t() | none()
  def get_by_id(id) do
    Document
    |> Repo.get(id)
  end
end

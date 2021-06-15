#
#  document.ex
#  livedocs
#
#  Created by d-exclaimation on 11:01.
#

defmodule Livedocs.Document do
  @moduledoc """
  Ecto Schema for document
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "document" do
    field(:body, :map)
    timestamps()
  end

  @type t() :: %__MODULE__{}

  @doc false
  def changeset(doc, attrs) do
    doc
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end

defmodule SpcData.Equipment do
  use SpcData.Schema
  import Ecto.Changeset

  schema "equipment" do
    field :model, :string

    timestamps()
  end

  def changeset(equipment, attrs) do
    equipment
    |> cast(attrs, [:model])
    |> validate_length(:model, min: 3, max: 25)
  end
end

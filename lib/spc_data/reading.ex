defmodule SpcData.Reading do
  use SpcData.Schema
  import Ecto.Changeset

  schema "readings" do
    field :value, :float
    belongs_to :equipment, SpcData.Equipment

    timestamps updated_at: false
  end

  def changeset(reading, attrs) do
    cast(reading, attrs, [:value, :equipment_id])
  end
end

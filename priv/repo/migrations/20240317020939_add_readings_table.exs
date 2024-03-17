defmodule SpcData.Repo.Migrations.AddReadingsTable do
  use Ecto.Migration

  def change do
    create table(:readings) do
      add :equipment_id, references(:equipment, on_delete: :delete_all), null: false
      add :value, :float, null: false

      timestamps(updated_at: false)
    end
  end
end

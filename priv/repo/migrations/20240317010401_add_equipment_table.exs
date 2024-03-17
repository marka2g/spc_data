defmodule SpcData.Repo.Migrations.AddEquipmentTable do
  use Ecto.Migration

  def change do
    create table(:equipment) do
      add :model, :string, null: false

      timestamps()
    end
  end
end

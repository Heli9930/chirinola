defmodule Chirinola.Repo.Migrations.AddFileNameColumn do
  use Ecto.Migration

  def up do
    alter table("plant_traits") do
      add :file, :text
    end
  end

  def down do
    alter table("plant_traits") do
      remove :file
    end
  end
end

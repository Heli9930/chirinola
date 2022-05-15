defmodule Chirinola.Repo.Migrations.AddPlantTraits do
  use Ecto.Migration

  def up do
    create table(:plant_traits, primary_key: true) do
      add :last_name, :string
      add :first_name, :string
      add :dataset_id, :integer
      add :dataset, :string
      add :species_name, :string
      add :acc_species_id, :integer
      add :acc_species_name, :string
      add :observation_id, :integer
      add :obs_data_id, :integer
      add :trait_id, :integer
      add :trait_name, :string
      add :data_id, :integer
      add :data_name, :string
      add :origl_name, :string
      add :orig_value_str, :string
      add :orig_unit_str, :string
      add :value_kind_name, :string
      add :orig_uncertainty_str, :string
      add :uncertainty_name, :string
      add :replicates, :float
      add :std_value, :float
      add :unit_name, :string
      add :rel_uncertainty_percent, :float
      add :orig_obs_data_id, :integer
      add :error_risk, :float
      add :reference, :text
      add :comment, :text
      add :no_name_column, :string
      timestamps()
    end
  end

  def down do
    drop table(:plant_traits)
  end
end
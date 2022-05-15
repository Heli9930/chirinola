defmodule Chirinola.Schema.PlantTraits do
  @moduledoc """
  Documentation for `Migrator`
  """

  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(last_name first_name dataset_id dataset species_name acc_species_id acc_species_name observation_id obs_data_id trait_id trait_name data_id data_name origl_name orig_value_str orig_unit_str value_kind_name orig_uncertainty_str uncertainty_name replicates std_value unit_name rel_uncertainty_percent orig_obs_data_id error_risk reference comment no_name_column)a

  schema "plant_traits" do
    field(:last_name, :string)
    field(:first_name, :string)
    field(:dataset_id, :integer)
    field(:dataset, :string)
    field(:species_name, :string)
    field(:acc_species_id, :integer)
    field(:acc_species_name, :string)
    field(:observation_id, :integer)
    field(:obs_data_id, :integer)
    field(:trait_id, :integer)
    field(:trait_name, :string)
    field(:data_id, :integer)
    field(:data_name, :string)
    field(:origl_name, :string)
    field(:orig_value_str, :string)
    field(:orig_unit_str, :string)
    field(:value_kind_name, :string)
    field(:orig_uncertainty_str, :string)
    field(:uncertainty_name, :string)
    field(:replicates, :float)
    field(:std_value, :float)
    field(:unit_name, :string)
    field(:rel_uncertainty_percent, :float)
    field(:orig_obs_data_id, :integer)
    field(:error_risk, :float)
    field(:reference, :string)
    field(:comment, :string)
    field(:no_name_column, :string)
    timestamps()
  end

  def changeset(plant_trait, params) do
    plant_trait
    |> cast(params, @fields)
  end
end
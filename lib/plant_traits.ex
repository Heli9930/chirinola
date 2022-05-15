defmodule Chirinola.PlantTrait do
    @moduledoc """
    Documentation for `PlantTrait` module.
    """
  
    require Logger
    alias Chirinola.Repo
    alias Chirinola.Schema.PlantTraits, as: PlantTraitsSchema
  
    @doc """
  
    """
    @spec insert(map()) :: {:ok, struct()} | {:error, Ecto.ChangeError}
    def insert(plant_traits_attrs) do
      %PlantTraitsSchema{}
      |> PlantTraitsSchema.changeset(plant_traits_attrs)
      |> Repo.insert()
      |> case do
        {:ok, plant_trait} ->
          {:ok, plant_trait}
  
        {:error, %Ecto.Changeset{changes: changes, errors: error}} ->
          Logger.error("ERROR WHILE INSERTING THE FOLLOWING RECORD:")
          Logger.info("#PARAMS: #{inspect(plant_traits_attrs)}")
          Logger.info("#CHANGES: #{inspect(changes)}")
          Logger.info("#ERROR DETAIL: #{inspect(error)}")
          File.write("errors-#{NaiveDateTime.utc_now()}.txt", changes)
          error
      end
    end
  
    @doc """
  
    """
    @spec insert_all(list()) :: {number(), list()} | nil
    def insert_all(plant_traits_attrs) do
      PlantTraitsSchema
      |> Repo.insert_all(plant_traits_attrs)
    end
  end
  
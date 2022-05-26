defmodule Chirinola.MigratorFast do
  @moduledoc """
  Documentation for `MigratorFast` module.
  """
  require Logger
  alias Chirinola.{QueueManager, Worker}

  @typedoc """
  Encoding modes, a tuple of two atoms.

  `{:encoding, :latin1}`, `{:encoding, :unicode}`, `{:encoding, :utf8}`,
  `{:encoding, :utf16}`, `{:encoding, :utf32}`, `{:encoding, {:utf16, :big}}`,
  `{:encoding, {:utf16, :little}}`, `{:encoding, {:utf32, :big}}`,
  `{:encoding, {:utf32, :little}}`
  """
  @type encoding_mode ::
          {
            :encoding,
            :latin1
            | :unicode
            | :utf8
            | :utf16
            | :utf32
            | {:utf16, :big | :little}
            | {:utf32, :big | :little}
          }

  @default_encoding {:encoding, :latin1}
  @valid_encondigs [
    {:encoding, :latin1},
    {:encoding, :unicode},
    {:encoding, :utf8},
    {:encoding, :utf16},
    {:encoding, :utf32},
    {:encoding, {:utf16, :big}},
    {:encoding, {:utf16, :little}},
    {:encoding, {:utf32, :big}},
    {:encoding, {:utf32, :little}}
  ]

  @wrong_path_message "Wrong path! Enter the absolute path of the file to migrate"
  @invalid_encoding_mode "The decoding format is invalid, check the valid formats"

  @n_processes 1..200
  @file_not_found_message "File not found, enter the absolute path of the file to migrate"
  @headers_line "LastName\tFirstName\tDatasetID\tDataset\tSpeciesName\tAccSpeciesID\tAccSpeciesName\tObservationID\tObsDataID\tTraitID\tTraitName\tDataID\tDataName\tOriglName\tOrigValueStr\tOrigUnitStr\tValueKindName\tOrigUncertaintyStr\tUncertaintyName\tReplicates\tStdValue\tUnitName\tRelUncertaintyPercent\tOrigObsDataID\tErrorRisk\tReference\tComment\t\n"

  @doc """
  Migrate data from a file to the `plant traits` table. The file is read line by line
  to avoid loading the entire file into memory.

  Provide the absolute path of the file to migrate as the first parameter,
  optionally you can provide as second parameter the encoding mode of the file
  to migrate (see `encoding_mode()` type).


  ## Examples

      iex> Chirinola.Migrator.start("some_file.txt")
      "** MIGRATION FINISHED!"
      :ok

      iex> Chirinola.Migrator.start("some_file.txt", {:encoding, :utf8})
      "** MIGRATION FINISHED!"
      :ok

  If the path provided is incorrect an error will be displayed

  ## Examples

      iex> Chirinola.Migrator.start("bad_file.txt")
      `File not found, enter the absolute path of the file to migrate, code: enoent`
      :error

  """

  # path = "/home/mono/Documentos/try/17728_27112021022449/17728.txt"
  # path = "/Users/ftitor/Downloads/17728_27112021022449/17728.txt"
  # path = "/Users/ftitor/Downloads/17728_27112021022449/test.txt"

  @spec start(String.t(), encoding_mode()) :: atom()
  def start(path, encoding_mode \\ @default_encoding)
  def start(nil, _encoding_mode), do: Logger.error(@wrong_path_message)
  def start("", _encoding_mode), do: Logger.error(@wrong_path_message)

  def start(_path, encoding_mode) when encoding_mode not in @valid_encondigs,
    do: Logger.error(@invalid_encoding_mode)

  def start(path, encoding_mode) do
    Logger.info("** MIGRATION PROCESS STARTED!")

    {:ok, queue_pid} = QueueManager.start_link()
    setup_process(queue_pid)

    path
    |> File.exists?()
    |> case do
      true ->
        Logger.info("** PROCESSING FILE (#{path})...")

        path
        |> File.stream!([encoding_mode], :line)
        |> Stream.map(&migrate_line(&1, queue_pid, Path.basename(path)))
        |> Stream.run()

        Logger.info("** MIGRATION FINISHED!")
        :ok

      false ->
        Logger.error(@file_not_found_message)
        :error
    end
  end

  defp setup_process(queue_pid) do
    @n_processes
    |> Enum.to_list()
    |> Enum.each(fn _ ->
      {:ok, worker_pid} = Worker.start_link()
      QueueManager.push(queue_pid, worker_pid)
    end)
  end

  defp migrate_line(line, _, _) when line == @headers_line,
    do: Logger.info("HEADERS REMOVED!")

  defp migrate_line("\n", _, _), do: Logger.info("EMPTY LINE")

  defp migrate_line(line, queue_pid, file_name) do
    line
    |> String.split("\n")
    |> Enum.at(0)
    |> String.split("\t")
    |> create_struct(file_name)
    |> insert_plant(queue_pid)
  end

  defp create_struct([], _), do: %{}

  defp create_struct(plant, file_name) do
    Map.new()
    |> Map.put("last_name", Enum.at(plant, 0))
    |> Map.put("first_name", Enum.at(plant, 1))
    |> Map.put("dataset_id", Enum.at(plant, 2))
    |> Map.put("dataset", Enum.at(plant, 3))
    |> Map.put("species_name", Enum.at(plant, 4))
    |> Map.put("acc_species_id", Enum.at(plant, 5))
    |> Map.put("acc_species_name", Enum.at(plant, 6))
    |> Map.put("observation_id", Enum.at(plant, 7))
    |> Map.put("obs_data_id", Enum.at(plant, 8))
    |> Map.put("trait_id", Enum.at(plant, 9))
    |> Map.put("trait_name", Enum.at(plant, 10))
    |> Map.put("data_id", Enum.at(plant, 11))
    |> Map.put("data_name", Enum.at(plant, 12))
    |> Map.put("origl_name", Enum.at(plant, 13))
    |> Map.put("orig_value_str", Enum.at(plant, 14))
    |> Map.put("orig_unit_str", Enum.at(plant, 15))
    |> Map.put("value_kind_name", Enum.at(plant, 16))
    |> Map.put("orig_uncertainty_str", Enum.at(plant, 17))
    |> Map.put("uncertainty_name", Enum.at(plant, 18))
    |> Map.put("replicates", validate_replicate(Enum.at(plant, 19)))
    |> Map.put("std_value", Enum.at(plant, 20))
    |> Map.put("unit_name", Enum.at(plant, 21))
    |> Map.put("rel_uncertainty_percent", Enum.at(plant, 22))
    |> Map.put("orig_obs_data_id", Enum.at(plant, 23))
    |> Map.put("error_risk", Enum.at(plant, 24))
    |> Map.put("reference", Enum.at(plant, 25))
    |> Map.put("comment", Enum.at(plant, 26))
    |> Map.put("no_name_column", Enum.at(plant, 27))
    |> Map.put("file", file_name)
  end

  defp insert_plant(plant, _) when map_size(plant) == 0, do: Logger.info("- EMPTY LINE")

  defp insert_plant(plant, queue_pid) do
    {:ok, worker_pid} = QueueManager.get_pid(queue_pid)

    Worker.insert(worker_pid, plant)
  end

  defp validate_replicate(nil), do: nil
  defp validate_replicate(""), do: nil
  defp validate_replicate(replicate) when is_float(replicate), do: replicate

  defp validate_replicate(replicate) when is_binary(replicate) do
    replicate
    |> Float.parse()
    |> case do
      {float, _} ->
        float

      :error ->
        Logger.error("Replicate invalid: #{replicate}")
        nil
    end
  end

  defp validate_replicate(_), do: nil
end

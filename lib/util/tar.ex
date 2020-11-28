defmodule Tex.Util.Tar do
  @moduledoc false
  @spec extract_tar_to_memory(binary) :: :error | {:ok, [{[any], binary}]}
  def extract_tar_to_memory(tar_file) when is_binary(tar_file) do
    case :erl_tar.extract(tar_file, [:compressed, :memory]) do
      {:ok, file_list} -> {:ok, file_list}
      _ -> :error
    end
  end

  @spec extract_tar_to_dir(binary, binary) :: {:error, any} | {:ok, binary}
  def extract_tar_to_dir(tar_file, destination) when is_binary(tar_file) and is_binary(destination) do
    case do_extract(tar_file, [:compressed, {:cwd, destination |> to_charlist}]) do
      :ok -> {:ok, destination}
      {:ok, _} -> {:ok, destination}
      {:error, err} -> {:error, err}
    end
  end

  @spec do_extract(binary, [
          :compressed
          | :cooked
          | :keep_old_files
          | :memory
          | :verbose
          | {:cwd, charlist()}
          | {:files, [[any]]}
        ]) :: :ok | {:error, any} | {:ok, [{[any], binary}]}
  def do_extract(file, opts) when is_binary(file) and is_list(opts) do
    :erl_tar.extract(file, opts)
  end
end

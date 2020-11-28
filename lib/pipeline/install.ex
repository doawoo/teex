defmodule Tex.Pipeline.Install do
  @moduledoc false

  alias Tex.Types.Library
  alias Tex.Types.Workspace
  alias Tex.Types.Error

  alias Tex.Util.Messages
  alias Tex.Util.Tar

  def run(%Library{tarball: nil}, _) do
    {:error, Error.build(type: :install, details: "Empty tarball passed into Install.run/2 pipeline")}
  end

  def run(%Library{} = lib, %Workspace{installed_libraries: current_libs} = target_workspace) do
    if !File.dir?(target_workspace.path) do
      {:error, Error.build(type: :workspace, details: "Workspace directory does not exist")}
    else
      with {:ok, tar_path} <- save_outer_tarball(lib),
      {:ok, inner_tarball} <- extract_inner_tarball(tar_path),
      {:ok, _lib_path} <- install_inner_tarball(target_workspace, lib, inner_tarball),
      :ok <- install_and_compile(target_workspace, lib) do
        lib = struct(lib, tarball: nil)
        {:ok, struct(target_workspace, installed_libraries: [lib | current_libs])}
      else
        error -> error
      end
    end
  end

  defp save_outer_tarball(%Library{} = lib) do
    temp_file = Path.join(System.tmp_dir!(), lib.name <> lib.version <> ".tar")

    with {:ok, file_handle} <- File.open(temp_file, [:write]),
    :ok <- IO.binwrite(file_handle, lib.tarball),
    :ok <- File.close(file_handle) do
      {:ok, temp_file}
    else
      _ -> {:error, Error.build(type: :install, details: "Failed to extract inner tarball from outter tarball")}
    end
  end

  defp extract_inner_tarball(tar_location) do
    Messages.outbox("Extracting inner tarball from outter tarball")
    with {:ok, file_list} <- Tar.extract_tar_to_memory(tar_location),
    {'contents.tar.gz', compressed_content} <- Enum.find(file_list, fn {file, _} -> file == 'contents.tar.gz' end) do
      {:ok, compressed_content}
    else
      _ -> {:error, Error.build(type: :install, details: "Failed to extract inner tarball from outter tarball")}
    end
  end

  def install_inner_tarball(%Workspace{} = workspace, %Library{} = lib, tar_data) do
    lib_dir = Path.join(workspace.path, lib.name)
    |> Path.join(lib.version)
    file_path = Path.join(lib_dir, "contents.tar.gz")

    with :ok <- File.mkdir_p(lib_dir),
    {:ok, file_handle} <- File.open(file_path, [:write]),
    :ok <- IO.binwrite(file_handle, tar_data),
    :ok <- File.close(file_handle) do
      Tar.extract_tar_to_dir(file_path, lib_dir)
    else
      err -> {:error, Error.build(type: :install, details: "Failed to install the inner tarball", data: err)}
    end
  end

  defp install_and_compile(%Workspace{} = workspace, %Library{} = lib) do
    Messages.wrench("Installing #{lib.name} @ #{lib.version} into workspace: #{workspace.name}")

    lib_path = Path.join([workspace.path, lib.name, lib.version])

    Messages.package("Fetching and compiling deps for #{lib.name} @ #{lib.version}")
    System.cmd("mix", ["deps.get"], cd: lib_path, stderr_to_stdout: true)
    System.cmd("mix", ["deps.compile"], cd: lib_path, stderr_to_stdout: true)

    Messages.tools("Compiling #{lib.name} @ #{lib.version}")
    System.cmd("mix", ["compile"], cd: lib_path, stderr_to_stdout: true)

    :ok
  end
end

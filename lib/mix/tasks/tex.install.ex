defmodule Mix.Tasks.Teex.Install do
  @moduledoc false
  use Mix.Task

  alias Teex.Types.Library
  alias Teex.Types.Workspace

  alias Teex.Pipeline.Download
  alias Teex.Pipeline.Install

  alias Teex.Util
  alias Teex.Util.Messages
  alias Teex.Util.Configuration

  def run(args) do
    OptionParser.parse!(args, strict: [workspace: :string, name: :string, version: :string])
    |> case do
      {[workspace: workspace_name], [name, version]} -> kickoff_install(workspace_name, name, version)
      _ ->
        IO.puts("Not sure what you mean!\n")
        IO.puts("\tUsage:\n\tTeex install jason 1.2.1 --workspace [target_workspace name]")
    end
  end

  defp kickoff_install(workspace_name, name, version) do
    Messages.info("Going to install Hex library #{name}@#{version} into workspace: #{workspace_name}")

    Messages.inbox("Downloading from hex...")

    {:ok, lib} = Library.build(
      name: name,
      version: version
    ) |> Download.run()

    workspace_name = Util.clean_workspace_name(workspace_name)
    full_path = Util.compute_workspace_path(workspace_name)

    if !File.dir?(full_path) do
      Messages.error("Workspace #{workspace_name} does not exist!")
      exit(-1)
    end

    {:ok, workspace} = Workspace.build(
      name: workspace_name,
      path: full_path
    ) |> Configuration.load_workspace()

    if already_installed(workspace, lib) do
      Messages.warning("Library '#{lib.name}' is already installed! Won't install it again!")
    else
      {:ok, workspace} = Install.run(lib, workspace)

      {:ok, _} = Configuration.save_workspace(workspace)

      Messages.sparkle("Finished installing!")
    end
  rescue
    e -> Messages.error("Failed to download or install the package, does that package and version exist?\n#{inspect(e)}")
  end

  defp already_installed(workspace, lib) do
    Enum.find(workspace.installed_libraries, nil, fn installed ->
      installed.name == lib.name
    end) != nil
  end
end

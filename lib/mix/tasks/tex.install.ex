defmodule Mix.Tasks.Tex.Install do
  use Mix.Task

  alias Tex.Types.Library
  alias Tex.Types.Workspace

  alias Tex.Pipeline.Download
  alias Tex.Pipeline.Install

  alias Tex.Util
  alias Tex.Util.Configuration

  require Logger

  def run(args) do
    OptionParser.parse!(args, strict: [workspace: :string, name: :string, version: :string])
    |> case do
      {[workspace: workspace_name], [name, version]} -> kickoff_install(workspace_name, name, version)
      _ -> Logger.info("Not sure what you mean, please provide a Hex package name, version, and --workspace")
    end
  end

  defp kickoff_install(workspace_name, name, version) do
    Logger.info("Going to install Hex library #{name}@#{version} into workspace: #{workspace_name}")

    {:ok, lib} = Library.build(
      name: name,
      version: version
    ) |> Download.run()

    Logger.info("Downloading from hex...")

    workspace_name = Util.clean_workspace_name(workspace_name)
    full_path = Util.compute_workspace_path(workspace_name)

    {:ok, workspace} = Workspace.build(
      name: workspace_name,
      path: full_path
    ) |> Configuration.load_workspace()

    {:ok, workspace} = Install.run(lib, workspace)

    {:ok, _} = Configuration.save_workspace(workspace)

    Logger.info("Finished installing!")
  end
end

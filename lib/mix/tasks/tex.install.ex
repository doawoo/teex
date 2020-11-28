defmodule Mix.Tasks.Tex.Install do
  use Mix.Task

  alias Tex.Types.Library
  alias Tex.Types.Workspace

  alias Tex.Pipeline.Download
  alias Tex.Pipeline.Install

  alias Tex.Util
  alias Tex.Util.Messages
  alias Tex.Util.Configuration

  def run(args) do
    OptionParser.parse!(args, strict: [workspace: :string, name: :string, version: :string])
    |> case do
      {[workspace: workspace_name], [name, version]} -> kickoff_install(workspace_name, name, version)
      _ ->
        IO.puts("Not sure what you mean!\n")
        IO.puts("\tUsage:\n\ttex install jason 1.2.1 --workspace [target_workspace name]")
    end
  end

  defp kickoff_install(workspace_name, name, version) do
    Messages.info("Going to install Hex library #{name}@#{version} into workspace: #{workspace_name}")

    Messages.download("Downloading from hex...")

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

    {:ok, workspace} = Install.run(lib, workspace)

    {:ok, _} = Configuration.save_workspace(workspace)

    Messages.sparkle("Finished installing!")
  rescue
    e -> Messages.error("Failed to download or install the package, does that package and version exist?\n#{inspect(e)}")
  end
end

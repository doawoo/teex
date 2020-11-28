defmodule Mix.Tasks.Tex.Uninstall do
  @moduledoc false
  use Mix.Task

  alias Tex.Types.Workspace

  alias Tex.Util
  alias Tex.Util.Messages
  alias Tex.Util.Configuration

  def run(args) do
    OptionParser.parse!(args, strict: [workspace: :string, name: :string, version: :string])
    |> case do
      {[workspace: workspace_name], [name]} -> kickoff_uninstall(workspace_name, name)
      _ ->
        IO.puts("Not sure what you mean!\n")
        IO.puts("\tUsage:\n\ttex uninstall jason --workspace [target_workspace name]")
    end
  end

  defp kickoff_uninstall(workspace_name, name) do
    Messages.info("Going to uninstall '#{name}' from workspace #{workspace_name}")

    Messages.wrench("Deleting...")

    workspace_name = Util.clean_workspace_name(workspace_name)
    full_path = Util.compute_workspace_path(workspace_name)

    if !File.dir?(full_path) do
      Messages.error("Workspace #{workspace_name} does not exist!")
      exit(-1)
    end

    {:ok, %Workspace{} = workspace} = Workspace.build(
      name: workspace_name,
      path: full_path
    ) |> Configuration.load_workspace()

    installed = Enum.find(workspace.installed_libraries, nil, fn item ->
      item.name == name
    end)

    if installed == nil do
      Messages.error("Workspace '#{workspace_name}' does not have the library '#{name}' installed!")
    else
      new_libs_list = Enum.reject(workspace.installed_libraries, fn item ->
        item.name == name
      end)

      workspace = struct(workspace, installed_libraries: new_libs_list)
      {:ok, _} = Configuration.save_workspace(workspace)

      Messages.sparkle("Uninstalled '#{name}' from workspace '#{workspace.name}'")
    end
  end
end

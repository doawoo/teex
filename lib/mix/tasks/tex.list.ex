defmodule Mix.Tasks.Teex.List do
  @moduledoc false
  use Mix.Task

  alias Teex.Types.Workspace
  alias Teex.Types.Library

  alias Teex.Util
  alias Teex.Util.Messages
  alias Teex.Util.Configuration

  def run(args) do
    OptionParser.parse!(args, strict: [workspace: :string])
    |> case do
      {[workspace: workspace_name], _} -> list_workspace(workspace_name)
      _ -> list_all()
    end
  end

  defp list_all() do
    path = Util.get_teex_home() |> Path.join("workspaces")
    dirs = File.ls!(path)
    Enum.each(dirs, fn dir ->
      if File.dir?(dir) do
        name = Path.basename(dir)
        list_workspace(name)
        IO.puts("")
      end
    end)
  end

  defp list_workspace(name) do
    workspace_name = Util.clean_workspace_name(name)
    full_path = Util.compute_workspace_path(workspace_name)

    if !File.dir?(full_path) do
      Messages.error("Workspace #{workspace_name} does not exist!")
      exit(-1)
    end

    {:ok, workspace} = Workspace.build(
      name: workspace_name,
      path: full_path
    ) |> Configuration.load_workspace()

    IO.puts("Workspace: #{name}")

    Enum.each(workspace.installed_libraries, fn %Library{} = lib ->
      IO.puts("#{lib.name} (#{lib.version})")
    end)
  end
end

defmodule Tex do
  alias Tex.Util
  alias Tex.Util.Configuration

  alias Tex.Types.Workspace
  alias Tex.Types.Library

  def main(args) do
    {cmd, rest} = List.pop_at(args, 0)
    case cmd do
      "init" -> Mix.Tasks.Tex.Init.run(rest)
      "install" -> Mix.Tasks.Tex.Install.run(rest)
      "workspace" -> Mix.Tasks.Tex.Workspace.run(rest)
      _ -> IO.puts("Not sure what you mean, try one of these commands: ['init', 'install', 'workspace']")
    end
  end

  def workspace(name) when is_binary(name) do
    workspace_name = Util.clean_workspace_name(name)
    full_path = Util.compute_workspace_path(workspace_name)

    Workspace.build(
      name: workspace_name,
      path: full_path
    )
    |> Configuration.load_workspace()
    |> case do
      {:ok, workspace} -> load_code_paths(workspace)
      _ -> {:error, "Workspace not found or corrupted"}
    end
  end

  defp load_code_paths(%Workspace{} = workspace) do
    Enum.each(workspace.installed_libraries, fn %Library{} = lib ->
      ebin_path =
        Path.join(workspace.path, lib.name)
        |> Path.join(lib.version)
        |> Path.join("_build/dev/lib/#{lib.name}/ebin")
      Code.append_path(ebin_path)
      IO.puts("Loaded: #{lib.name}@#{lib.version}")
    end)
  end
end

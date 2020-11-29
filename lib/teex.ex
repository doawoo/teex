defmodule Teex do
  alias Teex.Util
  alias Teex.Util.Configuration

  alias Teex.Types.Workspace
  alias Teex.Types.Library

  @doc false
  def main(args) do
    {cmd, rest} = List.pop_at(args, 0)
    case cmd do
      "init" -> Mix.Tasks.Teex.Init.run(rest)
      "install" -> Mix.Tasks.Teex.Install.run(rest)
      "uninstall" -> Mix.Tasks.Teex.Uninstall.run(rest)
      "workspace" -> Mix.Tasks.Teex.Workspace.run(rest)
      _ -> IO.puts("Not sure what you mean, try one of these commands: ['init', 'install', 'uninstall', 'workspace']")
    end
  end

  @spec workspace(binary) :: :ok | {:error, <<_::256>>}
  @doc """
  Use this function to load a Teex workspace during an IEx session or during an Elixir session
  that your ~/.teex.exs file has been loaded into.

  This will load the code paths required to run the libraries installed inside the specified workspace.
  """
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
      load_deps(workspace, lib)

      ebin_path =
        Path.join(workspace.path, lib.name)
        |> Path.join(lib.version)
        |> Path.join("_build/dev/lib/#{lib.name}/ebin")
      Code.append_path(ebin_path)
      IO.puts(:stderr, "Loaded library: #{lib.name}@#{lib.version}")
    end)
  end

  defp load_deps(workspace, lib) do
    Enum.each(lib.deps, fn {name, version} ->
      ebin_path =
        Path.join(workspace.path, lib.name)
        |> Path.join(lib.version)
        |> Path.join("_build/dev/lib/#{name}/ebin")

      Code.append_path(ebin_path)
      IO.puts(:stderr, "Loaded dependency: #{name}@#{version}")
    end)
  end
end

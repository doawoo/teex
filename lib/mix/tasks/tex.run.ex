defmodule Mix.Tasks.Tex.Run do
  use Mix.Task

  alias Tex.Types.Workspace

  alias Tex.Util
  alias Tex.Util.Configuration

  require Logger

  def run(args) do
    [workspace_name] = args
    run_workspace(workspace_name)
  end

  defp run_workspace(workspace_name) do
    full_path = Util.compute_workspace_path(workspace_name)
    {:ok, workspace} = Workspace.build(
      path: full_path
    ) |> Configuration.load_workspace()

    script_loader_lines = Enum.map(workspace.installed_libraries, fn %Tex.Types.Library{} = lib ->
      path = Path.join(full_path, "#{lib.name}/#{lib.version}/_build/dev/lib/#{lib.name}/ebin/")
      """
      true = Code.prepend_path("#{path}")
      Logger.info("Tex - Loaded library into workspace: #{lib.name}@#{lib.version}")
      """
    end) |> Enum.join()

    script = "require Logger\n" <> script_loader_lines

    out_path = Path.join(System.tmp_dir!(), "tex-boot-#{workspace.name}-#{:os.system_time(:millisecond)}.exs")

    File.write!(out_path, script)
  end
end

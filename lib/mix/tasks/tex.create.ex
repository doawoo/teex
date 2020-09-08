defmodule Mix.Tasks.Tex.Create do
  use Mix.Task

  alias Tex.Util
  alias Tex.Types.Workspace

  require Logger

  def run(["workspace", name]) do
    full_path = Util.compute_workspace_path(name)

    if File.dir?(full_path) do
      Logger.warn("Workspace #{name} already exists! Not creating it again.")
      exit(0)
    end

    Logger.info("Creating a new workspace: #{name}")

    File.mkdir_p!(full_path)
    workspace = Workspace.build(
      name: name,
      path: full_path
    )

    {:ok, _} = Util.Configuration.save_workspace(workspace)

    Logger.info("Workspace created!")
    Logger.info("Name: #{name}")
    Logger.info("Path: #{full_path}")
  end

  def run(_) do
    IO.puts("Not sure what you mean!")
    :ok
  end
end

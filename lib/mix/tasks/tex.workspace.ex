defmodule Mix.Tasks.Tex.Workspace do
  use Mix.Task

  alias Tex.Util
  alias Tex.Types.Workspace

  require Logger

  def run(["create", name]) do
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

  def run(["destroy", name]) do
    full_path = Util.compute_workspace_path(name)

    if !File.dir?(full_path) do
      Logger.warn("Workspace #{name} does not exist!")
      exit(0)
    end

    Logger.info("WARNING: This will delete the directory: #{full_path}!")

    confirmation = IO.gets("Destroy Workspace? [y/n] ")
    |> String.downcase()
    |> String.trim()
    cond do
      String.downcase(confirmation) == "y" ->
        File.rm_rf!(full_path)
        Logger.info("Workspace destroyed!")
      true ->
        Logger.info("Not destroying workspace, goodbye!")
    end
  end

  def run(_) do
    IO.puts("Not sure what you mean!")
    :ok
  end
end

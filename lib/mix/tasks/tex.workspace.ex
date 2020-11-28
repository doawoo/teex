defmodule Mix.Tasks.Tex.Workspace do
  @moduledoc false
  use Mix.Task

  alias Tex.Util
  alias Tex.Util.Messages
  alias Tex.Types.Workspace

  def run(["create", name]) do
    full_path = Util.compute_workspace_path(name)

    if File.dir?(full_path) do
      Messages.warning("Workspace #{name} already exists! Not creating it again.")
      exit(0)
    end

    Messages.wrench("Creating a new workspace: #{name}")

    File.mkdir_p!(full_path)
    workspace = Workspace.build(
      name: name,
      path: full_path
    )

    {:ok, _} = Util.Configuration.save_workspace(workspace)

    Messages.sparkle("Workspace created!")
    Messages.info("Name: #{name}")
    Messages.info("Path: #{full_path}")
  rescue
    _e -> Messages.error("Failed to create or save workspace configuration. This might be a permissions error!")
  end

  def run(["destroy", name]) do
    full_path = Util.compute_workspace_path(name)

    if !File.dir?(full_path) do
      Messages.warning("Workspace #{name} does not exist!")
      exit(0)
    end

    Messages.warning("WARNING: This will delete the directory: #{full_path}!")
    Messages.warning("Destroy Workspace? [y/n]\n")

    confirmation = IO.gets("")
    |> String.downcase()
    |> String.trim()
    cond do
      String.downcase(confirmation) == "y" ->
        File.rm_rf!(full_path)
        Messages.info("Workspace destroyed!")
      true ->
        Messages.info("Not destroying workspace, goodbye!")
    end
  end

  def run(_) do
    IO.puts("Not sure what you mean!\n")
    IO.puts("\tUsage:\n\ttex workspace create [new_workspace_name]")
    IO.puts("\ttex workspace destroy [workspace_name]")
    :ok
  end
end

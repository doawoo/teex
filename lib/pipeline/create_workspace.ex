defmodule Tex.Pipeline.CreateWorkspace do
  alias Tex.Types.Workspace
  alias Tex.Types.Error

  alias Tex.Util

  @spec run(any) :: {:error, atom} | {:ok, Workspace.t()}
  def run(workspace_name) do
    workspace_path = Path.join(Util.get_tex_home(), workspace_name)
    new_workspace = Workspace.build(name: workspace_name, path: workspace_path)
    with :ok <- File.mkdir_p(workspace_path),
    {:ok, workspace} <- Util.Configuration.save_workspace(new_workspace) do
      {:ok, workspace}
    else
      err -> {:error, Error.build(type: :workspace, details: "Failed to create workspace", data: err)}
    end
  end
end

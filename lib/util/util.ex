defmodule Tex.Util do
  def get_tex_home() do
    default_home = Path.join(System.user_home!(), ".tex")
    System.get_env("TEX_HOME", default_home)
  end

  @spec clean_workspace_name(binary) :: binary
  def clean_workspace_name(name) do
    Regex.replace(~r/[^\w\s]/, name, "", global: true)
    |> String.trim()
    |> String.downcase()
    |> String.replace(" ", "_")
  end

  @spec compute_workspace_path(binary) :: binary
  def compute_workspace_path(name) do
    name = clean_workspace_name(name)
    Path.join(get_tex_home(), "workspaces") |> Path.join(name)
  end
end

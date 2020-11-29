defmodule Teex.Util.Configuration do
  @moduledoc false

  alias Teex.Types.Workspace
  alias Teex.Types.Error

  @spec save_workspace(Teex.Types.Workspace.t()) ::
          {:error, %{:__struct__ => atom, optional(atom) => any}} | {:ok, Teex.Types.Workspace.t()}
  def save_workspace(%Workspace{} = workspace) do
    config_path = Path.join(workspace.path, "workspace.config")
    with true <- File.dir?(workspace.path),
      binary <- :erlang.term_to_binary(workspace),
      {:ok, file_handle} <- File.open(config_path, [:write]),
      :ok <- IO.binwrite(file_handle, binary) do
        _ = File.close(file_handle)
        {:ok, workspace}
      else
        err -> {:error, Error.build(type: :workspace, details: "Failed to write workspace config file", data: err)}
      end
  end

  @spec load_workspace(Teex.Types.Workspace.t()) ::
          {:error, %{:__struct__ => atom, optional(atom) => any}} | {:ok, Teex.Types.Workspace.t()}
  def load_workspace(%Workspace{} = workspace) do
    config_path = Path.join(workspace.path, "workspace.config")
    with true <- File.exists?(config_path),
      {:ok, data} <- File.read(config_path),
      %Workspace{} = loaded_workspace <- :erlang.binary_to_term(data) do
        {:ok, loaded_workspace}
      else
        err -> {:error, Error.build(type: :workspace, details: "Failed to load workspace config file", data: err)}
      end
  end
end

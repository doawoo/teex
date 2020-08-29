defmodule Mix.Tasks.Tex.Install do
  use Mix.Task
  require Logger

  def run(args) do
    OptionParser.parse!(args, strict: [workspace: :string, name: :string, version: :string])
    |> case do
      {[workspace: workspace_name], [name, version]} -> kickoff_install(workspace_name, name, version)
      _ -> Logger.info("Not sure what you mean, please provide a Hex package name, version, and --workspace")
    end
  end

  defp kickoff_install(workspace_name, name, version) do
    Logger.info("Going to install Hex library #{name}@#{version} into workspace: #{workspace_name}")
  end
end

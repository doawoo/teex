defmodule Mix.Tasks.Tex.Create do
  use Mix.Task

  require Logger

  def run(["workspace", name]) do
    Logger.info("Creating a new workspace: #{name}")
  end

  def run(_) do
    IO.puts("Not sure what you mean!")
    :ok
  end
end

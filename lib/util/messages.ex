defmodule Teex.Util.Messages do
  @moduledoc false
  require Logger

  @spec info(binary) :: :ok
  def info(message) when is_binary(message) do
    _ = Logger.info("ℹ️  #{message}")
  end

  @spec warning(binary) :: :ok
  def warning(message) when is_binary(message) do
    _ = Logger.warn("🚧  #{message}")
  end

  @spec error(binary) :: :ok
  def error(message) when is_binary(message) do
    _ = Logger.error("🚨  #{message}")
  end

  ### More fun ones

  @spec sparkle(binary) :: :ok
  def sparkle(message) when is_binary(message) do
    _ = Logger.info("✨ #{message} ✨")
  end

  @spec lights(binary) :: :ok
  def lights(message) when is_binary(message) do
    _ = Logger.info("💡 #{message} 💡")
  end

  @spec tools(binary) :: :ok
  def tools(message) when is_binary(message) do
    _ = Logger.info("🛠️  #{message}")
  end

  @spec wrench(binary) :: :ok
  def wrench(message) when is_binary(message) do
    _ = Logger.info("🔧 #{message}")
  end

  @spec package(binary) :: :ok
  def package(message) when is_binary(message) do
    _ = Logger.info("📦 #{message}")
  end

  @spec cd(binary) :: :ok
  def cd(message) when is_binary(message) do
    _ = Logger.info("💽 #{message}")
  end

  @spec inbox(binary) :: :ok
  def inbox(message) when is_binary(message) do
    _ = Logger.info("📥 #{message}")
  end

  @spec outbox(binary) :: :ok
  def outbox(message) do
    _ = Logger.info("📤 #{message}")
  end

  @spec think(binary) :: :ok
  def think(message) when is_binary(message) do
    _ = Logger.info("🤔 #{message}")
  end
end

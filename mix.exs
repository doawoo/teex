defmodule Teex.MixProject do
  use Mix.Project

  @source_url "https://github.com/doawoo/teex"

  def project do
    [
      app: :teex,
      version: "0.5.0",
      elixir: "~> 1.10",
      source_url: @source_url,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      description: description(),
      package: package(),
      escript: escript()
    ]
  end

  defp escript() do
    [main_module: Teex]
  end

  defp package() do
    [
      name: "teex",
      licenses: ["MIT"],
      maintainers: ["Digit"],
      links: %{"GitHub" => @source_url}
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description() do
    "Use Elixir as a scripting language with Hex packages, anywhere on your system. No Mix project required!"
  end

  defp deps do
    [
      {:typed_struct, "0.2.1"},
      {:jason, "~> 1.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:tesla, "~> 1.3.0"}
    ]
  end

  defp docs do
    [extras: ["README.md"], main: "readme"]
  end
end

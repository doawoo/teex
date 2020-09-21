defmodule Tex.MixProject do
  use Mix.Project

  def project do
    [
      app: :tex,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  defp package() do
    [
      name: "tex",
      licenses: ["MIT"],
      links: %{}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description() do
    "Tex is a way to provision quick and disposable elixir/hex workspaces"
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:typed_struct, "0.2.1"},
      {:jason, "~> 1.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:tesla, "~> 1.3.0"}
    ]
  end
end

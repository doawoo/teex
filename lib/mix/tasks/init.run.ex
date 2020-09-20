defmodule Mix.Tasks.Tex.Init do
  use Mix.Task

  require Logger

  defp init_file do
    """
    mix_arch_path = Mix.path_for(:archives)
    |> Path.join("tex-*")
    |> Path.wildcard()
    |> List.first()

    tex_base_name = Path.basename(mix_arch_path)
    ebin_path = Path.join(mix_arch_path, tex_base_name) |> Path.join("ebin")
    Code.append_path(ebin_path)

    IO.puts("Tex has been loaded into your IEx session!")
    """
  end

  def run(_) do
    home = System.user_home!()
    full_path = Path.join(home, ".tex.exs")
    File.write!(full_path, init_file())

    IO.puts("\nInstalled ~/.tex.exs")
    IO.puts("\nIMPORTANT! Add the following to the top of your ~/.iex.exs:\n")
    IO.puts("c \"#{full_path}\"\n")
  end
end

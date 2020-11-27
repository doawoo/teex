defmodule Mix.Tasks.Tex.Init do
  use Mix.Task

  alias Tex.Util.Messages

  @escript_util File.read!("lib/util/escript.ex")
  @modules_to_shim inspect(["Tex", "Tex.Types.Library", "Tex.Types.Workspace", "Tex.Types.Error", "Tex.Util", "Tex.Util.Configuration"])

  defp init_file do
    """
    #{@escript_util}

    Mix.path_for(:escripts)
    |> Path.join("tex")
    |> Tex.Util.Escript.extract_modules(#{@modules_to_shim})
    |> Tex.Util.Escript.load_module_object_code()

    IO.puts("Tex has been loaded into your IEx session!")
    """
  end

  def run(_) do
    home = System.user_home!()
    full_path = Path.join(home, ".tex.exs")
    File.write!(full_path, init_file())

    Messages.sparkle("Installed ~/.tex.exs")
    Messages.point("IMPORTANT! Add the following to the top of your ~/.iex.exs:")
    Messages.point("c \"#{full_path}\"")
  end
end

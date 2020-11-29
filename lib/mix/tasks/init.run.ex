defmodule Mix.Tasks.Teex.Init do
  @moduledoc false
  use Mix.Task

  alias Teex.Util.Messages

  @escript_util File.read!("lib/util/escript.ex")
  @modules_to_shim inspect(["Teex", "Teex.Types.Library", "Teex.Types.Workspace", "Teex.Types.Error", "Teex.Util", "Teex.Util.Configuration"])

  defp init_file do
    """
    #{@escript_util}

    Mix.path_for(:escripts)
    |> Path.join("Teex")
    |> Teex.Util.Escript.extract_modules(#{@modules_to_shim})
    |> Teex.Util.Escript.load_module_object_code()

    IO.puts(:stderr, "Teex has been loaded into your IEx session!")
    """
  end

  def run(_) do
    home = System.user_home!()
    full_path = Path.join(home, ".Teex.exs")
    File.write!(full_path, init_file())

    Messages.sparkle("Installed ~/.Teex.exs")
    Messages.lights("IMPORTANT! Add the following to the top of your ~/.iex.exs:")
    Messages.lights("c \"#{full_path}\"")
  end
end

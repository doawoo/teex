defmodule Tex.Util do
  def get_tex_home() do
    default_home = Path.join(System.user_home!(), ".tex")
    System.get_env("TEX_HOME", default_home)
  end
end

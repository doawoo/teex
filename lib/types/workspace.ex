defmodule Tex.Types.Workspace do
  use TypedStruct
  use Tex.Util.StructBuilder

  alias Tex.Types.Library

  typedstruct do
    field :name, String.t(), enforce: true, default: ""
    field :library_path, String.t(), enforce: true, default: ""
    field :installed_libraries, list(Library.t()), enforce: true, default: []
  end
end

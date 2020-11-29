defmodule Teex.Types.Workspace do
  @moduledoc false

  use TypedStruct
  use Teex.Util.StructBuilder

  alias Teex.Types.Library

  typedstruct do
    field :name, String.t(), enforce: true, default: ""
    field :path, String.t(), enforce: true, default: ""
    field :installed_libraries, list(Library.t()), enforce: true, default: []
  end

  builder()
end

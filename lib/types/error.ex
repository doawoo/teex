defmodule Tex.Types.Error do
  @moduledoc false

  use TypedStruct
  use Tex.Util.StructBuilder

  @type error_type :: :tarball | :download | :install | :workspace | :unknown

  typedstruct do
    field :type, error_type(), enforce: true, default: :unknown
    field :details, String.t(), enforce: true, default: ""
    field :data, Keyword.t(), enforce: true, default: []
  end

  builder()
end

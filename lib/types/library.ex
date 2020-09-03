defmodule Tex.Types.Library do
  use TypedStruct
  use Tex.Util.StructBuilder

  typedstruct do
    field :name, String.t(), enforce: true, default: ""
    field :version, String.t(), enforce: true, default: ""
    field :checksum, String.t(), enforce: true, default: ""
    field :tarball, binary(), enforce: true, default: nil
  end

  builder()
end

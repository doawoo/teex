defmodule Tex.Types.Library do
  use TypedStruct
  use Tex.Util.StructBuilder

  typedstruct do
    field :name, String.t(), enforce: true, default: ""
    field :tar_uri, URI.t(), enforce: true, default: %URI{}
    field :install_path, String.t(), enforce: true, default: ""
    field :checksum, String.t(), enforce: true, default: ""
  end
end

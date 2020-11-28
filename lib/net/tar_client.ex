defmodule Tex.Net.TarClient do
  @moduledoc false

  use Tesla, only: [:get]

  alias Tex.Types.Error

  plug Tesla.Middleware.BaseUrl, "https://repo.hex.pm/tarballs/"

  @tar_header <<86, 69, 82, 83, 73, 79, 78>>

  def download_tarball(name, version) do
    constructed_name = "#{name}-#{version}.tar"
    get(constructed_name)
    |> case do
      {:ok, resp} -> validate_download(resp.body)
      error -> Error.build(type: :download, details: "Failed to make request to fetch tar", data: error)
    end
  end

  defp validate_download(body) do
    case body do
      <<@tar_header, _rest :: binary>> -> {:ok, body}
      _ -> Error.build(type: :tarball, details: "Couldn't download a valid tar file, bad header.")
    end
  end
end

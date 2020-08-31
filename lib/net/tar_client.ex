defmodule Tex.Net.TarClient do
  use Tesla, only: [:get]

  plug Tesla.Middleware.BaseUrl, "https://repo.hex.pm/tarballs/"

  @tar_header <<86, 69, 82, 83, 73, 79, 78>>

  def download_tarball(name, version) do
    constructed_name = "#{name}-#{version}.tar"
    get(constructed_name)
    |> case do
      {:ok, resp} -> validate_download(resp.body)
      {:error, _} -> :error
    end
  end

  defp validate_download(body) do
    case body do
      <<@tar_header, _rest :: binary>> -> {:ok, body}
      _ -> {:error, "Failed to download tarball, bad header"}
    end
  end
end

defmodule Tex.Net.TarClient do
  use Tesla, only: [:get]

  plug Tesla.Middleware.BaseUrl, "https://repo.hex.pm/tarballs/"

  def download_tarball(name, version) do
    constructed_name = "#{name}-#{version}.tar"
    get(constructed_name)
    |> case do
      {:ok, resp} -> validate_download(resp.body)
      {:error, _} -> :error
    end
  end

  defp validate_download(body) do
    {:ok, body}
  end
end

defmodule Teex.Net.ReleasesClient do
  @moduledoc false
  use Tesla, only: [:get]

  plug Tesla.Middleware.BaseUrl, "https://hex.pm/api/packages/"
  plug Tesla.Middleware.Headers, ["User-Agent": "TeexClient"]

  @spec get_release_info(binary, binary) :: {:error, any} | map
  def get_release_info(package, version) when is_binary(package) and is_binary(version) do
    constructed_path = "#{package}/releases/#{version}"
    get(constructed_path)
    |> case do
      {:ok, resp} -> parse_release(resp.body, version)
      err -> err
    end
  end

  defp parse_release(data, version) do
    Jason.decode(data)
    |> case do
      {:ok, %{"status" => 400}} -> {:error, "Failed to fetch version"}
      {:ok, %{"version" => ^version} = info} -> info
      _ -> {:error, "Failed to parse version response"}
    end
  end
end

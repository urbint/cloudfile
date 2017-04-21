defmodule Cloudfile.Utils do
  @moduledoc """
  Hosts utility functions to support Cloudfile business logic.

  """


  @doc """
  Convenience function for extracting the scheme from a URI and returning the
  string required to fetch the resource.

  ## Examples

    iex> Cloudfile.Utils.extract_protocol("https://google.com/path/to/file")
    {:http, "https://google.com/path/to/file"}

    iex> Cloudfile.Utils.extract_protocol("gcs://path/to/file")
    {:gcs, "/path/to/file"}

    iex> Cloudfile.Utils.extract_protocol("/path/to/file")
    {:local, "/path/to/file"}

  """
  @spec extract_protocol(Cloudfile.uri) :: {Cloudfile.protocol, Cloudfile.path}
  def extract_protocol(path) do
    case URI.parse(path) do
      %URI{scheme: "http", path: path}  -> {:http, path}
      %URI{scheme: "https", path: path} -> {:http, path}
      %URI{scheme: "gcs", path: path} -> {:gcs, path}
      %URI{scheme: nil, path: path} -> {:local, path}
    end
  end
end
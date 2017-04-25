defmodule CloudFile.Drivers.HTTP do
  @moduledoc """
  Implements the `CloudFile.Driver` behaviour for HTTP storage.

  Note: This module depends on HTTPoison.
  Todo: Refactor impl to use an HTTP adapter so that other HTTP drivers can be
  used.

  """

  @behaviour CloudFile.Driver

  alias CloudFile.Drivers.HTTP.Utils, as: HttpUtils

  @standard_warning """
  `#{__MODULE__}`'s implementation assumes a RESTful API that complies to
  standard HTTP verbs and response status codes.
  """

  @note_on_errors """
  Errors are generated by the HTTP driver, `HTTPoison`. The module attempts to
  map errors into POSIX compliant filesystem errors. Any unrecognized errors are
  forwarded to the consumer un-altered.
  """


  @spec init :: :ok | no_return
  def init, do: :ok


  @doc """
  Returns the list of supported schemes for the HTTP driver.

  Note: this driver is responsible for both `http` and `https` protocols.

  #{@standard_warning}

  """
  @spec supported_schemes :: [CloudFile.scheme]
  def supported_schemes, do: ["http", "https"]


  @doc """
  Reads from the endpoint specified by `url`. Uses a `GET` request under the
  hood.

  #{@note_on_errors}

  #{@standard_warning}

  """
  @spec read(CloudFile.uri) :: {:ok, binary} | {:error, CloudFile.reason}
  def read(url) do
    with {:ok, res} <- HTTPoison.get(url) do
      case HttpUtils.response_successful?(res) do
        true  -> {:ok, res.body}
        false -> {:error, HttpUtils.to_posix(res)}
      end
    else
      {:error, _reason} = err -> err
    end
  end


  @doc """
  Writes to the endpoint specified by `url`. Uses a `POST` request under the
  hood.

  #{@note_on_errors}

  #{@standard_warning}

  """
  @spec write(CloudFile.uri, binary) :: :ok | {:error, CloudFile.reason}
  def write(url, content) do
    with {:ok, res} <- HTTPoison.post(url, content) do
      case HttpUtils.response_successful?(res) do
        true  -> {:ok, res.body}
        false -> {:error, HttpUtils.to_posix(res)}
      end
    else
      {:error, _reason} = err -> err
    end
  end


  @doc """
  Deletes the resource specified by `url`. Uses a `DELETE` request under the
  hood.

  #{@note_on_errors}

  #{@standard_warning}

  """
  @spec rm(CloudFile.uri) :: :ok | {:error, CloudFile.reason}
  def rm(url) do
    with {:ok, res} <- HTTPoison.delete(url) do
      case HttpUtils.response_successful?(res) do
        true  -> {:ok, res.body}
        false -> {:error, HttpUtils.to_posix(res)}
      end
    else
      {:error, _reason} = err -> err
    end
  end


end

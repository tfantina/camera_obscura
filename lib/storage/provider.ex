defmodule CameraObscura.Provider do
  @moduledoc """
  `Provider` is an behaviour for working with storage locally or via S3 compatable images.
  """

  @type ok_t :: {:ok, any()}
  @type error_t :: {:error, any()}
  @type config_t :: map()
  @type file_url_t :: {:local | :remote, String.t()}

  @doc """
  Providers need to be initialized with a map of options such as `root` URL and 
  a `url_prefix`. Eg:

    ```
    def init(opts) do 
        %{root: Keyword.fetch!(opts, :root)}
    end 
    ```
  """
  @callback init(opts :: Keyword.t()) :: config_t()

  @doc """
  Returns an image URL eg:

    ```
    def url(%{url_prefix: prefix}, key, _opts) do 
       {:ok, {:remote, Path.join(prefix, key)}
    end
    ```
  """
  @callback url(config :: config_t(), key :: String.t(), opts :: Keyword.t()) ::
              {:ok, file_url_t()} | error_t()

  @doc """
  Takes a blob and writes it to a file directory
  """
  @callback upload(config :: config_t(), key :: String.t(), io :: iodata(), opts :: Keyword.t()) ::
              {:ok, UUID.t()} | error_t()

  @doc """
  Downloads a file from an image provider
  """
  @callback download(config :: config_t(), key :: String.t()) :: ok_t() | error_t()

  @doc """
  Deletes a file from an image provider
  """
  @callback delete(config_t :: config_t(), key :: String.t()) :: :ok | error_t()

  @doc false
  @callback exists?(config_t :: config_t(), key :: String.t()) :: boolean()
end

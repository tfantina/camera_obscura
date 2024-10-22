defmodule CameraObscura.LocalProvider do
  @moduledoc """
  An ilementation of `CameraObscura.Provider` this will store files locally.
  Use this code as a template if you would like to implement S3 or some other storage.
  You may find it useful to look at a dependency such as ExAWS.
  """

  require Logger

  @behaviour Provider

  @spec ok(any()) :: {:ok, any()}
  defmacro ok(term), do: quote(do: {:ok, unquote(term)})

  @spec error(any()) :: {:error, any()}
  defmacro error(term), do: quote(do: {:error, unquote(term)})

  @impl true
  def init(opts \\ []) do
    root = Keyword.fetch!(opts, :root)
    url_prefix = Keyword.get(opts, :url_prefix, root)
    File.mkdir_p!(root)

    %{root: root, url_prefix: url_prefix}
  end

  @impl true
  def url(%{url_prefix: url_prefix}, key, _opts \\ []) do
    case validate_key(key) do
      :ok ->
        ok({:local, Path.join(url_prefix, key)})

      _ ->
        {:local, "/"}
    end
  end

  @impl true
  def upload(%{root: root}, key, io, opts \\ []) do
    with :ok <- validate_key(key),
         path <- Path.join(root, key),
         dir <- Path.dirname(path),
         :ok <- File.mkdir_p(dir),
         :ok <- File.write!(path, io, opts) do
      {:ok, key}
    else
      {:error, _} = error -> error
      res -> {:error, res}
    end
  end

  @impl true
  def download(%{root: root}, key) do
    with :ok <- validate_key(key) do
      root
      |> Path.join(key)
      |> File.read()
    end
  end

  @impl true
  def delete(%{root: root}, key) do
    with :ok <- validate_key(key) do
      root
      |> Path.join(key)
      |> File.rm()
    end
  end

  @impl true
  def exists?(%{root: root}, key) do
    case validate_key(key) do
      :ok ->
        root
        |> Path.join(key)
        |> File.exists?()

      _ ->
        false
    end
  end

  defp validate_key(key) when is_binary(key) do
    if String.match?(key, ~r/(\.\.)|(\/)|\/|(%)/) do
      :ok
    else
      error(:invalid_key)
    end
  end
end

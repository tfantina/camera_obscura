defmodule CameraObscura.ImageGenerators do
  @moduledoc """
  Behaviours for uploading an image and creating variants based on that image.
  """
  @type ok_t :: {:ok, any()}
  @type error_t :: {:error, any()}

  @doc false
  @callback create_image(String.t(), integer(), Keyword.t()) ::
              ok_t() | error_t()

  @doc false
  @callback create_variant(image :: Image.t(), opts :: String.t()) ::
              ok_t() | error_t()

  @doc false
  @callback variants() :: List.t()
end
defmodule CameraObscura.Pipeline do
  @moduledoc """
  Image and Image variant management.
  This macro implements an image pipeline that will upload a signle image and generate
  variant sizes.

  While implementations of `CameraObscura.Storage`, or the `Image` library could
  be used elsewhere, the goal with this module is to abstract as much as possible so that
  any module that uses this macro can hit the ground running and generating images.

  To implement this macro call `use` and pass a `domain` string (domain categorizes
  images and allows us to put images in seperate buckets if needed), and a list of `variants`:

  eg. `["100x100", "400x400", "1000x1400"]`

  Each variant size will create a resized version of the original image. Variants are created
  with the `Image` library (this is used because of it's ability to choose a focus spot when
  cropping) and run under an `ImageWorker` job.
  """

  @doc false
  defmacro __using__(opts \\ []) do
    domain = Keyword.get(opts, :domain)
    variants = Keyword.get(opts, :variants)
    app = Keyword.get(opts, :otp_app)

    quote do
      alias CameraObscura.UploadedImage
      alias CameraObscura.ImageVariant
      alias Image, as: ImageLibrary

      use CameraObscura.Storage, otp_app: unquote(app)
      @behaviour CameraObscura.ImageGenerators

      @doc """
      As parameters
      we take:
      * a bitstring of file data (for direct uploading into an S3 bucket)
      * the size of the original image (this helps keep track of total storage an individual user is using)
      * optional params

      At the moment the only optional param is `:resize` which, by default is true.
      Passing `resize: false` will prevent any resize jobs from running.
      """
      @impl true
      def create_image(data, size, opts \\ []) do
        with key when is_binary(key) <- Nanoid.generate(),
             {:ok, key} <- upload(key, data),
             image <- %UploadedImage{
               key: key,
               domain: unquote(domain),
               description: Keyword.get(opts, :description),
               size: size
             },
             variants <- Keyword.get(opts, :variants) || unquote(variants),
             {:ok, variants} <- maybe_create_variants(image, data, variants) do
          {:ok, %{image | variants: variants}}
        else
          err -> {:error, err}
        end
      end

      defp maybe_create_variants(image, data, [_ | _] = variants) do
        variants =
          Enum.reduce(variants, [], fn variant, acc ->
            [create_variant(image, data, variant) | acc]
          end)

        case Enum.any?(variants, &has_error?(&1)) do
          false -> {:ok, variants}
          true -> {:error, variants}
        end
      end

      defp maybe_create_variants(_image, _data, _variants), do: {:ok, []}

      defp has_error?({:error, _}), do: true
      defp has_error?(_), do: false

      @doc """
      Called by resizing jobs, takes a image and a size string (eg. "100x120") and 
      generates a smaller variant.
      """
      @impl true
      def create_variant(image, data, variant) do
        with {:ok, from_binary} <- ImageLibrary.from_binary(data),
             {:ok, thumb} <- ImageLibrary.thumbnail(from_binary, variant),
             {:ok, data} <- ImageLibrary.write(thumb, :memory, suffix: ".jpg"),
             {:ok, %UploadedImage{} = new_image} <- create_image(data, "0", variants: []) do
          {:ok,
           %ImageVariant{
             key: new_image.key,
             domain: image.domain,
             description: image.description,
             size: new_image.size,
             parent: image.key
           }}
        else
          err -> {:error, err}
        end
      end

      @doc """
      Gets a list of variant sizes from the macro implementation.
      """
      @impl true
      def variants do
        unquote(variants)
      end
    end
  end
end

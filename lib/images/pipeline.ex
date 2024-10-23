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

  alias CameraObsucra.{Image, ImageStruct}
  alias Ecto.{Multi, UUID}

  alias Image, as: ImageLibrary

  @doc false
  defmacro __using__(opts \\ []) do
    domain = Keyword.get(opts, :domain)
    variants = Keyword.get(opts, :variants)
    app = Keyword.get(opts, :otp_app)

    quote do
      use CameraObscura.Storage, otp_app: unquote(app)
      @behaviour CameraObscura.Storage

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
        # Multi.new()
        # |> put_multi_value(:key, UUID.generate())
        # |> Multi.run(:upload_photo, fn _, %{key: key} ->
        #   upload(key, data)
        # end)
        # |> Multi.run(:image, fn _, %{upload_photo: key} ->
        #   %{record: record, size: size, key: key}
        #   |> create_params()
        #   |> Map.put(:domain, unquote(domain))
        #   |> ImageRecord.image_changeset()
        #   |> Repo.insert()
        # end)
        # |> Multi.run(:variants, fn _, %{image: image} ->
        #   img_job =
        #     if Keyword.get(opts, :resize, true) do
        #       image
        #       |> ImageWorker.new_resize_images()
        #       |> Oban.insert()
        #     else
        #       :no_resize
        #     end

        {:ok, :img_job}
      end

      # defp create_params(%{user: %{id: user_id}, record: %Post{id: post_id}, size: size, key: key}) do
      #   %{key: key, size: size, user_id: user_id, post_id: post_id}
      # end

      # defp create_params(%{
      #        user: %{id: user_id},
      #        record: %Place{id: place_id},
      #        size: size,
      #        key: key
      #      }) do
      #   %{key: key, size: size, user_id: user_id, place_id: place_id}
      # end

      # defp create_params(%{user: %{id: user_id}, size: size, key: key}) do
      #   %{key: key, size: size, user_id: user_id}
      # end

      @doc """
      Called by resizing jobs, takes a image and a size string (eg. "100x120") and generates
      a smaller variant.
      """
      @impl true
      def create_variant(img, size) do
        img
        # |> Images.get()
        # |> generate_and_upload_variant(size)
      end

      # defp generate_and_upload_variant(%{id: id, key: key}, size) do
      #   with {:ok, image} <- download(key),
      #        {:ok, image} <- ImageResizeLibrary.open(image),
      #        {:ok, thumb} <-
      #          ImageLibrary.thumbnail(image, size, crop: :attention, fit: :cover),
      #        {:ok, data} <- ImageLibrary.write(thumb, :memory, suffix: ".jpg") do
      #     @multi
      #     |> put_multi_value(:key, UUID.generate())
      #     |> Multi.insert(:variant, fn %{key: key} ->
      #       %ImageVariant{key: key, dimensions: size, image_id: id}
      #     end)
      #     |> Multi.run(:upload_photo, fn _, %{variant: variant, key: key} ->
      #       upload(key, data)
      #     end)
      #     |> Repo.transaction()
      #   else
      #     _ ->
      #       {:error, "Unable to create profile variant"}
      #   end
      # end

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

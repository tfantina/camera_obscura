defmodule CameraObscura.PipelineTest do
  alias __MODULE__
  alias CameraObscura.UploadedImage
  alias CameraObscura.ImageVaraint

  @variants ["60x60", "200x200"]
  use ExUnit.Case
  use CameraObscura.Pipeline, domain: "test", otp_app: :camera_obscura, variants: @variants

  setup do
    File.mkdir(Path.join(__DIR__, "../static/output/"))
    path = Path.join(__DIR__, "../static/stanley_park.jpg")
    data = File.read!(path)
    %{size: size} = File.stat!(path)

    on_exit(fn -> File.rm_rf!(Path.join(__DIR__, "../static/output/")) end)
    %{data: data, size: size}
  end

  describe "create_image/3" do
    test "Returns an image struct", ctxt do
      %{data: data, size: size} = ctxt

      assert {:ok, %UploadedImage{} = subject} = PipelineTest.create_image(data, size)
      assert not is_nil(subject.key)
      assert subject.size == size
      assert subject.domain == "test"
    end
  end
end

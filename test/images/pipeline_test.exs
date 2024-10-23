defmodule CameraObscura.PipelineTest do
  @variants ["60x60", "200x200"]
  use ExUnit.Case
  use CameraObscura.Pipeline, domain: "test", otp_app: :camera_obscura, variants: @variants

  describe "create_image/3" do
    Application.compile_env(:camera_obscura, CameraObscura.PipelineTest, []) |> IO.inspect()
  end
end

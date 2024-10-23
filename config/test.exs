import Config

config :camera_obscura, CameraObscura.PipelineTest,
  provider: CameraObscura.LocalProvider,
  root: Path.expand(Path.join(__DIR__, "../test/static/output"))

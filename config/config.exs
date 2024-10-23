import Config

config :camera_obscura,
  screenshot_on_failure: false,
  js_errors: true,
  hackney_options: [timeout: :infinity, recv_timeout: :infinity]

import_config "#{config_env()}.exs"

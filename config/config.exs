import Config

config :nanoid,
  size: 12,
  alphabet: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

import_config "#{config_env()}.exs"

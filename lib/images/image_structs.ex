defmodule CameraObscura.Image do
  @moduledoc """
  An `%Image{}` is the base struct for passing Image data. It is structured to 
  contain:
    * `key`: which is an identifier, ie. a filename, or an S3 key
    * `domain`: which specifies an S3 bucket or specific model the image is associated with 
    * `description`: optional description or metadata 
    * `size`: image size in bytes
    * `variants`: a collection of differently sized variants. 
  """
  @enforce_keys [:key, :size]
  defstruct [:key, :domain, :description, :size, variants: []]
end

defmodule CameraObscura.ImageVariant do
  @moduledoc """
  An `%ImageVariant{}` contains all the attributes of an `%Image{}` except a list of 
  associated `variants`, instead we only reference the `parent` by it's key.
  """
  @enforce_keys [:key, :size, :parent]
  defstruct [:key, :domain, :description, :size, :parent]
end

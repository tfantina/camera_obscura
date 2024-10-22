CameraObscura 🎞️

A WIP Hex project to get image uploads/transformations working on the fly. 
A lot of this code was ported from an [social network called Ciao](https://github.com/tfantina/ciao_phx) I made a few years back. As such this is very much a WIP.  

The goal of this project is to stop reinventing the wheel when image uploads are required,
I would like to have a single library I can drop in that will do the work of consuming an
upload (from LiveView or another source), uploading the raw data to S3 and kicking off a job to create one or multiple image variants. 

## How it Works

CameraObscura provides a series of behaviours for uploading images to a bucket, transforming those images with the `Image` library, and returning variants of the original image.  
You can think "Cloudinary in my Elixir app". This met the needs of my little social network where resizing images and cropping to specific aspect ratios was very important.

The best documentation is to look at the specific behaviours found in `Provider` and `ImageGenerators`.

`ImageGenerators` is an API for consuming raw data and returning it as either a single `Image` or a series of `ImageVariant`s.  Variants depend on how you use the behaviour.  Eg.

   ```
   @variants ["200x200", "500x500"]
   use CameraObscura.ImageGenerators, domain: "accounts", otp_app: :my_app, variants: @variants
   ```
In this case the original `Image` will be created with two variants (200x200 and 500x500). 
The domain is a way of organizing images for sending to a specific bucket or pattern matching 
on the result that CameraObscura returns. A lot more functionality is going to be added to 
this behavour (see the to do section below).


`Provider` is an API to communicate with your local file system or an S3 provider depending on how you implement these behaviours. For example you may have a `dev.exs` file with a `LocalProvider` which interfaces with your local system while `prod.exs` could utilize a `TigrisProvider` to send files to Tigris or any other S3 provider. This behavour will likely remain fairly small in scope and act, only as an intermediary between your project and an S3 provider.



Because this is very much a work in progress rather than installation instructions I am 
posting a to do list with goals for the project:


## To Do:

- [ ] Migrate `Pipeline` module away from Ecto based transactions 
- [ ] Allow users to pass a specific worker module into the `Pipeline` module to run transforms with a job 
- [ ] Write a test suite 
- [ ] Allow for variants other than size (B&W)
- [ ] Generate meta descriptions using Bumblebee?


Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/camera_obscura>.



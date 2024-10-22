# CameraObscura 🎞️

A WIP Hex project to get image uploads/transformations working on the fly. 
A lot of this code was ported from an [social network called Ciao](https://github.com/tfantina/ciao_phx) I made a few years back. As such this is very much a WIP.  

The goal of this project is to stop reinventing the wheel when image uploads are required,
I would like to have a single libray I can drop in that will do the work of consuming an
upload (from LiveView or another source), uploading the raw data to S3 and kicking off a job to create one or multiple image variants. 

Because this is very much a work in progress rather than installation instructions I am 
posting a to do list with goals for the project:


## To Do:

- [ ] Migrate `Pipeline` module away from Ecto based transactions 
- [ ] Allow users to pass a specific worker module into the `Pipeline` module to run transforms with a job 
- [ ] Write a test suite 
- [ ] Allow for variants other than size (B&W)
- [ ] Generate meta descrptions using Bumblebee?


Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/camera_obscura>.


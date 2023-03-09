#:___________________________________________________
#  ngl  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:___________________________________________________

#___________________
# Package
packageName   = "ngl"
version       = "0.0.0"
author        = "sOkam"
description   = "Nim Graphics Library"
license       = "MIT"

#___________________
# Folders
srcDir           = "src"
binDir           = "bin"
let testsDir     = "tests"
let examplesDir  = "examples"
let docDir       = "doc"
skipdirs         = @[binDir, examplesDir, testsDir, docDir]

#___________________
# Build requirements
requires "nim >= 1.6.10"   ## Latest stable version
requires "https://github.com/heysokam/nstd"  ## Nim stdlib extension
requires "staticglfw"      ## For window creation. GLFW bindings, without dynamic libraries required
requires "vmath"           ## For vector math
requires "chroma"          ## Color manipulation
requires "shady"           ## For native Nim shaders
requires "boxy"            ## For GPU-based image/font loading, management and packing. Includes pixie


#________________________________________
# Helpers
#___________________
import std/os
import std/strformat
#___________________
let nimcr = &"nim c -r --outdir:{binDir}"
  ## Compile and run, outputting to binDir
proc runFile (file, dir :string) :void=  exec &"{nimcr} {dir/file}"
  ## Runs file from the given dir, using the nimcr command
proc runTest (file :string) :void=  file.runFile(testsDir)
  ## Runs the given test file. Assumes the file is stored in the default testsDir folder
proc runExample (file :string) :void=  file.runFile(examplesDir)
  ## Runs the given test file. Assumes the file is stored in the default testsDir folder


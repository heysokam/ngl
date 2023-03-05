#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________

#______________________________________________
# Renamed:
#   Constants are PascalCase
#   Functions are camelCase
#   Some functions are overloaded to Nim types
#   Some functionality is unified or simplified, like `gl.init()` or `gl.clear()`
#   Some names are shortened, like `Tex2D` instead of GL_TEXTURE_2D
#   Some names are reworded for categorization priority, like FilterMag instead of GL_TEXTURE_MAG_FILTER
#   Lack of parenthesis right next to GL types means type conversion. Like   GLint loc   is converting loc nim type to GLint
#___________________
# Added:
#   Logging
#   Debugging
#   Native types support (in some cases) and converters
#   Clear takes arguments
#   setCull, setBlend, setDepth, disDepth, setDebug
#   string conversions
#______________________________________________

# Cable connectors to the OpenGL module
import ./gl/buffer  ; export buffer
import ./gl/debug   ; export debug
import ./gl/info    ; export info
import ./gl/logger  ; export logger
import ./gl/names   ; export names
import ./gl/shader  ; export shader
import ./gl/texture ; export texture
import ./gl/tools   ; export tools
import ./gl/types   ; export types
import ./gl/uniform ; export uniform
import ./gl/view    ; export view


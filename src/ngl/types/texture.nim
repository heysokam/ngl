#:___________________________________________________
#  ngl  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:___________________________________________________
# External dependencies
import pkg/pixie
import pkg/opengl  # Cannot come from render/gl.nim, because of logger to cfg import cycle
# ndk dependencies
import nstd/types
# Module dependencies
import ../gl/texture as gl
import ./base  as rTypes


#____________________
const NotInitialized * = "UninitializedTexture"  ## Name for uninitialized Texture objects

#_____________________________
type FilterType * = enum 
  Nearest       = gl.Nearest             ## Nearest fragment defines pixel color
  Linear        = gl.Linear              ## Bilinear interpolation defines pixel color
  LinearLinear  = gl.LinearMipmapLinear  ## Mipmap levels are also interpolated to find the pixel color
#____________________
type Filter * = object
  `min`  *:FilterType  ## Minification  filter. Applied when size of a texel is reduced
  mag    *:FilterType  ## Magnification filter. Applied when size of a texel is augmented

#_____________________________
type WrapType * = enum
  Clamp   = gl.Clamp
  Repeat  = gl.Repeat
#____________________
type Wrap * = object
  S  *:WrapType  ## Wrap type along X axis
  T  *:WrapType  ## Wrap type along Y axis

#_____________________________
type Texture * = ref object of OpenGLObj
  typ     *:GLEnum   ## OpenGL texture type (GLTexture2D, 3D, etc)
  file    *:str      ## File name
  name    *:str      ## Internal name of the texture (shader uniform, etc)
  img     *:Image    ## Image data, in premultiplied format (aka ColorRGBX)
  mips    *:i32      ## Amount of mipmap levels that will be generated
  filter  *:Filter   ## Filter type for OpenGL
  wrap    *:Wrap     ## Type of wrapping used for S and T coordinates


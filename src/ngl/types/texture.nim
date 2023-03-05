#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# External dependencies
import pkg/pixie
import pkg/opengl  # Cannot come from render/gl.nim, because of logger to cfg import cycle
# ndk dependencies
import nstd/types
# Module dependencies
import ./base  as rTypes


#____________________
type Texture * = ref object of OpenGLObj
  typ  *:GLEnum   ## OpenGL texture type (GLTexture2D, 3D, etc)
  file *:str      ## File name
  img  *:Image    ## Image data, in premultiplied format (aka ColorRGBX)


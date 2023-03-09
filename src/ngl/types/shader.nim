#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# ndk dependencies
import nstd/types
# Module dependencies
import ./base  as rTypes


#____________________
type ShaderBase * = ref object of OpenGLObj
  file *:str  ## File path where this shader is read from
  src  *:str  ## Source code of the shader
type ShaderVert * = ShaderBase
type ShaderFrag * = ShaderBase
type ShaderProg * = ref object of OpenGLObj


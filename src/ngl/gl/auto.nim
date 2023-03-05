#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# External dependencies
import pkg/opengl


#______________________________________________
# Automatic conversion from OpenGL types to Nim
#___________________
converter toBool  *(cond :GLboolean) :bool=   cond == GL_TRUE
converter toInt32 *(cond :GLboolean) :int32=  cond.ord.int32

#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# External dependencies
import pkg/opengl
import pkg/chroma


#______________________________________________
# General helpers
#___________________
proc toString *(pc :ptr GLchar; length :GLsizei) :string=
  ## Gets a nim string for an OpenGL char pointer with the specified length
  result = newStringOfCap(length)
  for ch in cast[ptr UncheckedArray[char]](pc).toOpenArray(0, length-1):
    result.add(ch)

#______________________________________________
# Custom tools
#___________________
proc init *() :void=  opengl.loadExtensions()
  ## Initializes the OpenGL context
  ## Shorthand for loadExtensions()
#____________________
proc clear *(color :Color= color(0.1, 0.1, 0.1, 1); colorBit :bool= true; depthBit :bool= true) :void=
  ## Clears the OpenGL context.
  ## Defaults when omitted:
  ## - color: 0.1 gray by default. pure magenta when debug
  ## - bits:  color and depth cleared
  # Clear color
  var c :Color= color
  when defined(debug): c = color(1,0,1,1) # Strong magenta for debug version
  glClearColor(c.r, c.g, c.b, c.a)
  # Clear bits
  var bits :GLbitfield
  if colorBit: bits = bits or GL_COLOR_BUFFER_BIT
  if depthBit: bits = bits or GL_DEPTH_BUFFER_BIT
  glClear(bits)
#____________________
proc setBlend *() :void=
  ## Set OpenGL blend mode
  glEnable(GLBlend)
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
#____________________
proc setCull *() :void=
  ## Set OpenGL faceculling
  glEnable(GLCullFace)  # Default disabled
  glFrontFace(GLccw)    # Default CCW
  glCullFace(GLback)    # Default Back
#____________________
proc setDepth *() :void=  glEnable(GLDepthTest)   ## Enables OpenGL depth testing
proc disDepth *() :void=  glDisable(GLDepthTest)  ## Disables OpenGL depth testing



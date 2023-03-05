#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# std dependencies
import std/strformat
# External dependencies
import pkg/opengl
# Module dependencies
import ../logger ; export logger # log function is set and stored in ngl/logger file

#____________________
# Log parameters
type LogGLparm * = object
  id   :uint
  name :string
  typ  :string
converter toLogGLparm *(tup :tuple[id :uint, name, typ :string]) :LogGLparm=
  LogGLparm(id: tup.id, name: tup.name, typ: tup.typ)
#______________________________
const glParamT :seq[tuple[id :GLEnum, name, typ :string]]= @[
  (GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS, "GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS", "int"), #0
  (       GL_MAX_CUBE_MAP_TEXTURE_SIZE,        "GL_MAX_CUBE_MAP_TEXTURE_SIZE", "int"), #1
  (                GL_MAX_DRAW_BUFFERS,                 "GL_MAX_DRAW_BUFFERS", "int"), #2
  ( GL_MAX_FRAGMENT_UNIFORM_COMPONENTS,  "GL_MAX_FRAGMENT_UNIFORM_COMPONENTS", "int"), #3
  (         GL_MAX_TEXTURE_IMAGE_UNITS,          "GL_MAX_TEXTURE_IMAGE_UNITS", "int"), #4
  (                GL_MAX_TEXTURE_SIZE,                 "GL_MAX_TEXTURE_SIZE", "int"), #5
  (              GL_MAX_VARYING_FLOATS,               "GL_MAX_VARYING_FLOATS", "int"), #6
  (              GL_MAX_VERTEX_ATTRIBS,               "GL_MAX_VERTEX_ATTRIBS", "int"), #7
  (  GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS,   "GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS", "int"), #8
  (   GL_MAX_VERTEX_UNIFORM_COMPONENTS,  "GL_MAX_FRAGMENT_UNIFORM_COMPONENTS", "int"), #9
  (               GL_MAX_VIEWPORT_DIMS,                "GL_MAX_VIEWPORT_DIMS", "int2"), #10
  (                          GL_STEREO,                           "GL_STEREO", "bool"), #11
]
#______________________________
proc logParms *(file :string; log :proc) :void=
  "GL Context Parameters:".log
  for param in glParamT:
    if param.typ in ["int"]:  # Integers: The parameter will be one int
      var v :GLint= 0
      glGetIntegerv(param.id, v.caddr)
      (&"{param.name} {v}").log
    elif param.typ in ["int2"]: # Int2 : The parameter will be an array of two ints
      var arr :array[2, GLint]
      glGetIntegerv(param.id, arr[0].addr);
      (&"{param.name} {arr[0]} {arr[1]}").log
    elif param.typ in ["bool"]: # bool : The parameter will be true/false
      var b :GLboolean
      glGetBooleanv(param.id, b.addr)
      (&"{param.name} {b}").log
    else: continue


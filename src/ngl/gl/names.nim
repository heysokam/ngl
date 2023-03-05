#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# std dependencies
import std/tables
# External dependencies
import pkg/opengl
# ndk dependencies
import nstd/macros  # For GLEnum conversion to lit names

#____________________
# GLEnum Names: Lookup Table
const EnumName :Table[GLEnum, string]= {
  GL_MAX_CUBE_MAP_TEXTURE_SIZE         : getLitName(GL_MAX_CUBE_MAP_TEXTURE_SIZE),
  GL_MAX_DRAW_BUFFERS                  : getLitName(GL_MAX_DRAW_BUFFERS),
  GL_MAX_FRAGMENT_UNIFORM_COMPONENTS   : getLitName(GL_MAX_FRAGMENT_UNIFORM_COMPONENTS),
  GL_MAX_TEXTURE_IMAGE_UNITS           : getLitName(GL_MAX_TEXTURE_IMAGE_UNITS),
  GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS  : getLitName(GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS),
  GL_MAX_TEXTURE_SIZE                  : getLitName(GL_MAX_TEXTURE_SIZE),
  GL_MAX_VARYING_FLOATS                : getLitName(GL_MAX_VARYING_FLOATS),
  GL_MAX_VERTEX_ATTRIBS                : getLitName(GL_MAX_VERTEX_ATTRIBS),
  GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS    : getLitName(GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS),
  GL_MAX_VERTEX_UNIFORM_COMPONENTS     : getLitName(GL_MAX_VERTEX_UNIFORM_COMPONENTS),
  GL_MAX_VIEWPORT_DIMS                 : getLitName(GL_MAX_VIEWPORT_DIMS),
  GL_STEREO                            : getLitName(GL_STEREO),
}.toTable
#____________________
proc `$` *(v :GLEnum) :string= EnumName[v]
  ## Returns the given GLEnum name as a string, as stored in the known names Lookup Table.


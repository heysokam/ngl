#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# External dependencies
import pkg/chroma
import pkg/opengl  # Cannot come from render/gl.nim, because of logger to cfg import cycle
# ndk dependencies
import nstd/types
import nmath/types as m
# Module dependencies
import ./base as r

#____________________
type Attr *{.pure.}= enum aPos = 0, aColor, aUV, aNorm
converter toCInt *(att :Attr) :cint=  att.ord.cint
converter toU32  *(att :Attr) :u32=   att.ord.u32
#____________________
type OpenGLAttrib * = ref object of OpenGLObj
  ## Vertex Attribute metadata, as understood by OpenGL
  ## Will be used to link the VBO data into the currently bound VAO
  name    *:str
  size    *:i32
  typ     *:GLEnum
  stride  *:i32
#____________________
type VBO *[T]= ref object of OpenGLObj
  ## Vertex Buffer Object data and id
  data  *:seq[T]  ## Data buffer that holds the information required for rendering
#____________________
type MeshAttribute *[T]= object
  ## RenderMesh attribute.
  ## Contains all data and metadata needed to render one attribute for all vertex of a mesh
  attr  *:OpenGLAttrib   ## Metadata needed to register the attribute
  vbo   *:VBO[T]         ## Data and ID of the attribute buffer
#____________________
# TODO: Unsigned normalized data in opengl. how?
type VPos    = MeshAttribute[Vec3]
type VColor  = MeshAttribute[Color]  # 8bit likely enough. Maybe 16bit for HDR lights?
type VUV     = MeshAttribute[Vec2]   # Maybe 16bit floats ?
type VNorm   = MeshAttribute[Vec3]   # Maybe smaller than float32? unsigned 10/10/10/2 format?
#____________________
type VAO * = ref object of OpenGLObj
  ## Contains the buffer data needed to register and render a set of vertex attributes (except the ebo)
  ## VBOs are stored inside this object, as predetermined MeshAttributes that contain the buffer data in them
  # Could be a seq[MeshAttribute[T]], for cases of empty attributes, but the size save should be negligible
  pos    *:VPos
  color  *:VColor
  uv     *:VUV
  norm   *:VNorm

#____________________
type EBO *[T]= ref object of OpenGLObj
  data *:seq[T]
#____________________
type Indices * = EBO[UVec3]  # TODO: Could probably be part of the VAO too



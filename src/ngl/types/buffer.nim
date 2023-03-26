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
# Layout Bindings:  UBOs, SSBOs, etc
type BindID *{.pure.}= enum Matrix = 0, Camera, Light, None
  ## Explicit binding IDs for shader Uniforms. All shaders depend on them.
converter toCInt *(id :BindID) :cint=  id.ord.cint
converter toU32  *(id :BindID) :u32=   id.ord.u32
#____________________
# Layout Locations:  Vertex Attributes
type Attr *{.pure.}= enum aPos = 0, aColor, aUV, aNorm
  ## Explicit location IDs for shader attributes. All shaders depend on them.
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
type DBO [T]= ref object of OpenGLObj
  data  *:seq[T]  ## Data buffer that holds the information required for rendering
type VBO  *[T]= DBO[T]   ## Vertex Buffer Object data and id
type EBO  *[T]= DBO[T]   ## Elements Buffer Object data and id
type UBO  *[T]= DBO[T]   ## Uniform Buffer Object data and id
type SSBO *[T]= DBO[T]   ## Shader Storage Buffer Object data and id
type BO   *[T]= VBO[T] | EBO[T] | UBO[T] | SSBO[T]
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
type Indices * = EBO[UVec3]  # TODO: Could probably be part of the VAO too

#_________________________________________________
# Render Target
type Target *{.pure.}= enum Color, Depth, Stencil
type Targets * = set[Target]
#____________________
type RenderTarget * = ref object of OpenGLObj
  kind      *:Target   ## Type of RenderTarget that is stored
  size      *:Size     ## Size of the Target's texture
  colors    *:GLEnum  ## Color components of the target  (aka. gl.internalFormat)
  format    *:GLEnum  ## Format of the Pixel data
  typ       *:GLEnum  ## Type of the Pixel data
  attachID  *:uint32   ## Attachment ID of the RenderTarget. Color starts at id 0, and Depth/Stencil use their unique values
  clearVal  *:Vec4     ## Value to clear the buffer to. Stores single components and/or converted to ints when its relevant
#____________________
type RenderTargets * = seq[RenderTarget]

#____________________
# Framebuffer
type FBO * = ref object of OpenGLObj
  cont  *:Targets        ## List of Targets contained in the FBO. For faster content checking
  trg   *:RenderTargets  ## Targets contained in the Framebuffer



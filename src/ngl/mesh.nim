#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# ndk dependencies
import nstd/types  as base
import nstd/format
import nstd/C
import nmath/types as m
# Module dependencies
from   ./gl        as gl import nil
import ./types
import ./shader
import ./texture
import ./color
import ./C as Cgl
#____________________

#_______________________________________________________
# Empty Type Generation
#______________________________
proc newGLAttrib () :OpenGLAttrib= 
  new result
  result.name = "Uninitialized Attribute"
  result.id   = u32.high
  result.size = 0
  result.typ  = gl.Enum(0)
#____________________
proc newVBO [T]() :VBO[T]=
  new result
  result.id   = u32.high
  result.data = @[]
#____________________
proc newMeshAttrib (T :typedesc) :MeshAttribute[T]=  MeshAttribute[T](attr: newGLAttrib(), vbo: newVBO[T]())
#____________________
proc newVAO () :VAO=
  new result
  result.pos   = newMeshAttrib(Vec3)
  result.color = newMeshAttrib(Color)
  result.uv    = newMeshAttrib(Vec2)
  result.norm  = newMeshAttrib(Vec3)
#____________________
proc newEBO [T]() :EBO[T]=
  new result
  result.id   = u32.high
  result.data = @[]
#____________________
proc newRenderMesh *() :RenderMesh= 
  ## Creates a new RenderMesh, with all values set to 0 or empty
  RenderMesh(vao: newVAO(), inds: newEBO[UVec3](), shd: newShaderProg(), tex: newTexture())
#_______________________________________________________

#_______________________________________________________
# Normal Type Generation
#____________________
proc newGLAttrib *[T](name :str; id :u32; typ :typedesc[T]) :OpenGLAttrib=
  new result
  result.name = name
  result.id   = id
  when T is Vec3 or T is Vec2 or T is Color:
    result.typ = gl.Float
  when T is Color: result.size = 4; result.stride = result.size * sizeof(float32).i32
  elif T is Vec3:  result.size = 3; result.stride = result.size * sizeof(float32).i32
  elif T is Vec2:  result.size = 2; result.stride = result.size * sizeof(float32).i32

#______________________________
# Content Checks
#____________________
template hasPos   *(v :VAO) :bool=  v.pos.vbo.data.len   > 0  ## Checks whether or not the target VAO contains a position vbo, by calculating the length of the vbo.data
template hasColor *(v :VAO) :bool=  v.color.vbo.data.len > 0  ## Checks whether or not the target VAO contains a colors   vbo, by calculating the length of the vbo.data
template hasUV    *(v :VAO) :bool=  v.uv.vbo.data.len    > 0  ## Checks whether or not the target VAO contains a UVs      vbo, by calculating the length of the vbo.data
template hasNorm  *(v :VAO) :bool=  v.norm.vbo.data.len  > 0  ## Checks whether or not the target VAO contains a normals  vbo, by calculating the length of the vbo.data

#__________________________________________________
# TODO: Better naming system for objects
proc name *(m :RenderMesh) :str=  m.vao.id.reprb
#______________________________

#______________________________
# Enable/Disable Buffers
#______________________________
proc enable *(attr :OpenGLAttrib) :void=
  ## Enables the target OpenGL attribute metadata for the currently bound VAO
  gl.vertexAttribPointer(attr.id, attr.size.cint, attr.typ, false, 0, nil)
  gl.enableVertexAttribArray(attr.id)
#______________________________
proc disable *(attr :OpenGLAttrib) :void=  gl.disableVertexAttribArray(attr.id)
  ## Disables the target OpenGL attribute metadata
#______________________________
proc enable *(trg :VAO|VBO|EBO) :void= 
  ## Binds the selected buffer object
  ## VBO and EBO buffers only need binding for creating or changing their format
  when trg is VAO: gl.bindVertexArray(trg.id); return
  var typ :gl.Enum
  when trg is VBO: typ = gl.ArrayBuffer
  elif trg is EBO: typ = gl.ElementArrayBuffer
  gl.bindBuffer(typ, trg.id)
#______________________________
proc disable *(trg :VAO|VBO|EBO) :void= 
  ## Unbinds the selected buffer object type
  ## Does nothing if a buffer of this type is not currently bound
  # Binding to 0 is the same as unbinding
  when trg is VAO: gl.bindVertexArray(0); return
  var typ :gl.Enum
  when trg is VBO: typ = gl.ArrayBuffer
  elif trg is EBO: typ = gl.ElementArrayBuffer
  gl.bindBuffer(typ, 0)
#______________________________
template cleanState *(mesh :RenderMesh) :void=
  ## Cleans OpenGL state after managing a Mesh (unbind all buffers)
  #  Per-Object Attributes are bound to the VAO, and don't need to be disabled
  mesh.vao.disable
  mesh.vao.pos.vbo.disable  # Disabling any of the VBOs is enough, since only the last one is saved
  mesh.inds.disable

#______________________________
# Register Data
#____________________
proc register *[T](vao :VAO; ma :var MeshAttribute[T]; id :Attr) :void=
  ## Upload, bind and enable the given Vertex Attribute to OpenGL
  ## Binds the attribute based on their corresponding vao+vbo data (DSA) and its metadata
  ## Each attribute is assumed to be part of the given VAO, and have a unique VBO for itself
  # Create the VBO containers
  gl.createBuffers(1, ma.vbo.id.addr)
  gl.namedBufferStorage(ma.vbo.id, ma.vbo.csizeof, ma.vbo.caddr, gl.DynamicStorageBit)
  # Register and Enable the attribute metadata and buffer object
  ma.attr = newGLAttrib[T]($id, id, T)
  gl.vertexArrayVertexBuffer(vao.id, ma.attr.id, ma.vbo.id, 0, ma.attr.stride.cint)
  gl.enableVertexArrayAttrib(vao.id, ma.attr.id)
  gl.vertexArrayAttribFormat(vao.id, ma.attr.id, ma.attr.size.cint, ma.attr.typ, false, 0)
  gl.vertexArrayAttribBinding(vao.id, ma.attr.id, ma.attr.id)

#______________________________
proc register (vao :var VAO) :void=  gl.createVertexArrays(1, vao.id.addr)
  ## Creates the given VAO in OpenGL (DSA)

#______________________________
proc register (vao :VAO; ebo :var EBO) :void=
  ## Create and bind the given EBO to the target VAO in OpenGL (DSA)
  gl.createBuffers(1, ebo.id.addr)
  gl.namedBufferStorage(ebo.id, ebo.csizeof, ebo.caddr, gl.DynamicStorageBit)
  gl.vertexArrayElementBuffer(vao.id, ebo.id)

#______________________________
proc register (mesh :var RenderMesh) :void=
  ## Upload, bind and link all data and information from the given mesh into OpenGL (DSA)
  if not mesh.vao.hasPos: return  # Stop reading if no vertex, because other data will be irrelevant in that case
  mesh.vao.register                                                     # Register the VAO itself
  mesh.vao.register(mesh.inds)                                          # Register the Indices
  mesh.vao.register(mesh.vao.pos, Attr.aPos)                            # Register the Positions
  if mesh.vao.hasColor: mesh.vao.register(mesh.vao.color, Attr.aColor)  # Register the Colors
  if mesh.vao.hasUV:    mesh.vao.register(mesh.vao.uv,    Attr.aUV)     # Register the UVs
  if mesh.vao.hasNorm:  mesh.vao.register(mesh.vao.norm,  Attr.aNorm)   # Register the Normals
  mesh.tex.register                                                     # Register the Materials/Textures
#______________________________
proc register *(model :var RenderModel) :void=
  ## Upload, bind and link all data and information 
  ## from all meshes of a model into OpenGL
  for mesh in model.mitems: mesh.register

#______________________________
proc term *(v :VBO|EBO) :void=
  ## Deletes the target buffer from OpenGL memory (DSA)
  discard gl.unmapNamedBuffer(v.id)
  gl.deleteBuffers(1, v.id.addr)
  let t :str= when v is VBO: "VBO" elif v is EBO: "EBO"
  # log &"- {t} deleted"

#______________________________
template term *[T](ma :MeshAttribute[T]) :void=  ma.vbo.term
  ## Terminates the VBO contained in the target MeshAttribute

#______________________________
proc term *(v :VAO) :void=
  ## Terminates all data contained in the target VAO and all its contained attributes
  gl.deleteVertexArrays(1, v.id.addr) #; log "- VAO deleted"
  v.pos.term
  v.color.term
  v.uv.term
  v.norm.term

#______________________________
proc term *(m :RenderMesh) :void=
  ## Terminates all elements of the input mesh object
  # log &"Terminating object: {m.name}"
  m.vao.term
  m.inds.term
#__________________________________________________

proc term *(obj :RenderBody) :void=
  ## Terminates all data for all meshes of the target RenderBody
  for m in obj.mdl: m.term

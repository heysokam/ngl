#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# External dependencies
import pkg/chroma
# ndk dependencies
import nstd/types  as base
import nmath/types as m
# Module dependencies
import ./types/body
import ./types/buffer
from   ./gl as gl import nil


#_______________________________________________________
# Constructors: Empty
#____________________
proc newGLAttrib () :OpenGLAttrib=
  new result
  result.name = "Uninitialized Attribute"
  result.id   = u32.high
  result.size = 0
  result.typ  = gl.Enum(0)
#____________________
proc newVBO [T](data :seq[T]= @[]) :VBO[T]=
  new result
  result.id   = u32.high
  result.data = data
#____________________
proc newMeshAttrib (T :typedesc) :MeshAttribute[T]=
  MeshAttribute[T](attr: newGLAttrib(), vbo: newVBO[T]())
#____________________
proc newVAO *() :VAO=
  new result
  result.pos   = newMeshAttrib(Vec3)
  result.color = newMeshAttrib(Color)
  result.uv    = newMeshAttrib(Vec2)
  result.norm  = newMeshAttrib(Vec3)
#____________________
proc newEBO *[T](data :seq[T]= @[]) :EBO[T]=
  new result
  result.id   = u32.high
  result.data = data

#_______________________________________________________
# Constructors: General
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
#____________________
proc newMeshAttrib [T](t :typedesc; data: seq[T]; attr :Attr) :MeshAttribute[T]=
  MeshAttribute[T](attr: newGLAttrib($attr, attr, t), vbo: newVBO(data))
#____________________
proc newVAO *(
    verts   :seq[Vec3];
    colors  :seq[Color]=  @[]; 
    uvs     :seq[Vec2]=   @[]; 
    norms   :seq[Vec3]=   @[];
    ) :VAO=
  new result
  result.pos   = newMeshAttrib(Vec3,  verts,  Attr.aPos)
  result.color = newMeshAttrib(Color, colors, Attr.aColor)
  result.uv    = newMeshAttrib(Vec2,  uvs,    Attr.aUV)
  result.norm  = newMeshAttrib(Vec3,  norms,  Attr.aNorm)

#_______________________________________________________
# Content Checks
#____________________
template hasPos   *(v :VAO) :bool=  v.pos.vbo.data.len   > 0  ## Checks if the target VAO contains a position vbo, by calculating the length of the vbo.data
template hasColor *(v :VAO) :bool=  v.color.vbo.data.len > 0  ## Checks if the target VAO contains a colors   vbo, by calculating the length of the vbo.data
template hasUV    *(v :VAO) :bool=  v.uv.vbo.data.len    > 0  ## Checks if the target VAO contains a UVs      vbo, by calculating the length of the vbo.data
template hasNorm  *(v :VAO) :bool=  v.norm.vbo.data.len  > 0  ## Checks if the target VAO contains a normals  vbo, by calculating the length of the vbo.data
template hasMats  *(mesh :RenderMesh) :bool=  mesh.mats.len > 0  ## Checks if the given mesh has any materials attached
#____________________
proc getType (trg :VAO|BO) :gl.Enum=
  ## Returns the gl.Enum type of the given BufferObject, based on its native type.
  when trg is  VAO: return # Compiler wants to access this, even if it shouldn't. This will never be reached, only for linting.
  when trg is  VBO: result = gl.Array
  elif trg is  EBO: result = gl.ElementArray
  elif trg is  UBO: result = gl.Uniform
  elif trg is SSBO: result = gl.ShaderStorage

#_______________________________________________________
# Enable/Disable Buffers
#______________________________
proc enable *(trg :VAO|BO; id :BindID= BindID.None) :void= 
  ## Binds the selected buffer object.
  ## xBO buffers only need binding for changing their format.
  ## VBO|EBO don't need to be enabled, use the VAO instead, or their handle to modify them.
  ## `id` is only used for UBO|SSBO.
  when trg is VAO:      gl.bindVertexArray(trg.id); return
  var  typ :gl.Enum=    trg.getType()
  when trg is VBO|EBO:  gl.bindBuffer(typ, trg.id)
  elif trg is UBO|SSBO: gl.bindBufferRange(typ, id, trg.id, 0, trg.data.csizeof)
#______________________________
proc disable *(trg :VAO|BO) :void= 
  ## Unbinds the selected buffer object type
  ## Does nothing if a buffer of this type is not currently bound
  # Binding to 0 is the same as unbinding
  when trg is VAO: gl.bindVertexArray(0); return
  var typ :gl.Enum= trg.getType()
  gl.bindBuffer(typ, 0)

#_______________________________________________________
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
proc register *(vao :var VAO) :void=  gl.createVertexArrays(1, vao.id.addr)
  ## Creates the given VAO in OpenGL (DSA)
#______________________________
proc register *(vao :VAO; ebo :var EBO) :void=
  ## Create and bind the given EBO to the target VAO in OpenGL (DSA)
  gl.createBuffers(1, ebo.id.addr)
  gl.namedBufferStorage(ebo.id, ebo.csizeof, ebo.caddr, gl.DynamicStorageBit)
  gl.vertexArrayElementBuffer(vao.id, ebo.id)
#______________________________
proc register *(ubo :var UBO; bindId :BindID) :void=
  ## Create and bind the given UBO to OpenGL (DSA)
  gl.createBuffers(1, ubo.id.addr)
  gl.namedBufferStorage(ubo.id, ubo.csizeof, ubo.caddr, gl.DynamicStorageBit)

#______________________________
proc modify *[T](bo :var BO[T]; data :T) :void=
  ## Changes the BufferObject's data storage in OpenGL.
  var tmp :T= cast[T](gl.mapNamedBuffer(bo.id, gl.Write))
  bo.data = data
  tmp     = bo.data
  discard gl.unmapNamedBuffer(bo.id)
#______________________________
# proc glNamedBufferSubData(buffer: GLuint; offset: GLintptr; size: GLsizeiptr; data: pointer)
proc modifySection *[T](bo :var BO[T]; data :T; offs :u32= 0) :void=
  ## Changes a subset of the BufferObject's data storage in OpenGL.
  ## Offset will be 0 (start of the buffer) when omitted.
  ## NOTE: Better to use modify, which uses Map and Unmap.
  gl.namedBufferSubData(bo.id, offs, data.csizeof, data.caddr)


#______________________________
# Terminate Data
proc term *(v :BO) :void=
  ## Deletes the target buffer from OpenGL memory (DSA)
  gl.deleteBuffers(1, v.id.addr)
  let t :str= 
    when v is  VBO: "VBO" 
    elif v is  EBO: "EBO"
    elif v is  UBO: "UBO"
    elif v is SSBO: "SSBO"
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


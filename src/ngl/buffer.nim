#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# ndk dependencies
import nstd/types as base
# Module dependencies
import ./types/buffer
import ./gl/types as gl


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
proc newVAO (
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

#_______________________________________________________
# Enable/Disable Buffers
#______________________________
proc enable *(attr :OpenGLAttrib) :void=
  ## Enables the target OpenGL attribute metadata for the currently bound VAO
  gl.vertexAttribPointer(attr.id, attr.size.cint, attr.typ, false, 0, nil)
  gl.enableVertexAttribArray(attr.id)
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
proc disable *(attr :OpenGLAttrib) :void=  gl.disableVertexAttribArray(attr.id)
  ## Disables the target OpenGL attribute metadata
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
proc register (vao :var VAO) :void=  gl.createVertexArrays(1, vao.id.addr)
  ## Creates the given VAO in OpenGL (DSA)
#______________________________
proc register (vao :VAO; ebo :var EBO) :void=
  ## Create and bind the given EBO to the target VAO in OpenGL (DSA)
  gl.createBuffers(1, ebo.id.addr)
  gl.namedBufferStorage(ebo.id, ebo.csizeof, ebo.caddr, gl.DynamicStorageBit)
  gl.vertexArrayElementBuffer(vao.id, ebo.id)


#______________________________
# Terminate Data
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


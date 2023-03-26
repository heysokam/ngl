#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# ndk dependencies
import nstd/types  as base
import nstd/format
import nstd/C
import nmath/types as m
import nmath/trf
# Module dependencies
import ./types
import ./buffer
import ./shader
import ./texture
import ./material
import ./color
import ./C  as Cgl
from   ./gl as gl import nil

#_______________________________________________________
# Constructors: Empty
#______________________________
proc newRenderMesh *() :RenderMesh= 
  ## Creates a new RenderMesh, with all values set to 0 or empty
  RenderMesh(vao: newVAO(), inds: newEBO[UVec3](), mats: @[])
#____________________
proc newRenderBody *[T]() :RenderBody[T]=  RenderBody[T]()

#_______________________________________________________
# Constructors: General
#____________________
proc newRenderMesh *(
    verts    :seq[Vec3];
    inds     :seq[UVec3];
    colors   :seq[Color]=  @[];
    uvs      :seq[Vec2]=   @[];
    norms    :seq[Vec3]=   @[];
    mats     :Materials=   @[];
    ) :RenderMesh=
  ## Creates a new RenderMesh from the given data.
  ## Vertex positions and indices are mandatory. The other vertex attributes are optional.
  ## A valid compiled ShaderProg must be provided.
  ## Materials will be empty if omitted.
  RenderMesh(
    vao:  newVAO(verts, colors, uvs, norms),
    inds: newEBO(inds),
    mats: mats  )
#____________________
proc newRenderBody *[T](mdl :RenderModel; trf :Transform[T]) :RenderBody[T]=
  ## Creates a new RenderBody object from the given data
  ## Defaults when ommited: 
  ##   Empty sequence as its RenderModel
  ##   Empty Transform, with every value at 0
  RenderBody[T](mdl: mdl, trf: trf)

#__________________________________________________
# TODO: Better naming system for objects
proc name *(m :RenderMesh) :str=  m.vao.id.reprb

#______________________________
# Register Data to OpenGL
proc register *(mesh :var RenderMesh) :void=
  ## Upload, bind and link all data and information from the given mesh into OpenGL (DSA)
  if not mesh.vao.hasPos: return  # Stop reading if no vertex, because other data will be irrelevant in that case
  mesh.vao.register                                                     # Register the VAO itself
  mesh.vao.register(mesh.inds)                                          # Register the Indices
  mesh.vao.register(mesh.vao.pos, Attr.aPos)                            # Register the Positions
  if mesh.vao.hasColor: mesh.vao.register(mesh.vao.color, Attr.aColor)  # Register the Colors
  if mesh.vao.hasUV:    mesh.vao.register(mesh.vao.uv,    Attr.aUV)     # Register the UVs
  if mesh.vao.hasNorm:  mesh.vao.register(mesh.vao.norm,  Attr.aNorm)   # Register the Normals
  mesh.mats.register                                                     # Register the Materials/Textures
#______________________________
proc register *(model :var RenderModel) :void=
  ## Upload, bind and link all data and information 
  ## from all meshes of a model into OpenGL
  for mesh in model.mitems: mesh.register

#______________________________
# Terminate Data from OpenGL
proc cleanState *(mesh :RenderMesh) :void=
  ## Cleans OpenGL state after managing a Mesh (unbind all buffers)
  #  Per-Object Attributes are bound to the VAO, and don't need to be disabled
  mesh.vao.disable
  mesh.vao.pos.vbo.disable  # Disabling any of the VBOs is enough, since only the last one is saved
  mesh.inds.disable
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

#__________________________________________________
template world *(body :RenderBody) :Mat4=  body.trf.mat4


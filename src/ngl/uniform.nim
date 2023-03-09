#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# std dependencies
import std/strformat
# ndk dependencies
import nstd/types
import nstd/C
import nmath/types as m
# Module dependencies
import ./types/uniform
import ./types/shader as shdTypes
from   ./gl as gl import nil
import ./shader
import ./color


#______________________________
proc newUniform *(t :UniformData; name :str= "EmptyUniform"; ina :bool= true) :Uniform=
  ## Creates an new Uniform connector object with the given properties.
  result = Uniform(name: "EmptyUniform", ina: true)
  when t is i32:    result.kind = Kind.i32
  elif t is f32:    result.kind = Kind.f32
  elif t is Vec2:   result.kind = Kind.vec2
  elif t is Vec3:   result.kind = Kind.vec3
  elif t is Vec4:   result.kind = Kind.vec4
  elif t is Color:  result.kind = Kind.color
  elif t is Mat4:   result.kind = Kind.mat4

#______________________________
proc enable *(u :Uniform; data :UniformData) :void=
  ## Uploads the given data to the Uniform.data to OpenGL
  ## Requires that the uniform.id has been initialized
  if u.ina: return
  if u.kind == Kind.none: return
  when data is i32:    gl.uniform1iv(u.id, 1, data.caddr)
  elif data is f32:    gl.uniform1fv(u.id, 1, data.caddr)
  elif data is Vec2:   gl.uniform2fv(u.id, 1, data.caddr)
  elif data is Vec3:   gl.uniform3fv(u.id, 1, data.caddr)
  elif data is Vec4:   gl.uniform4fv(u.id, 1, data.caddr)
  elif data is Color:  gl.uniform4fv(u.id, 1, data.caddr)
  elif data is Mat4:   gl.uniformMatrix4fv(u.id, 1, false, data.caddr)





#______________________________
##[  TODO:
proc newUniform *(val :auto; name :str; shd :ShaderProg; enable :bool= false) :Uniform=
  ## Creates and registers a new uniform
  ## Will populate its id from the given shader and name
  ## The name is expected to exist in the shader
  ## It will not enable it by default, unless enable=true is specified
  # TODO: Error check
  result = val.uniform
  result.register(name, shd)
  if enable: result.enable
#______________________________
proc register *(u :var Uniform; name :str; shd :ShaderProg) :void=
  ## Initializes the id of the uniform from the given shader, searching the uniform by name
  if u.ina: return                 # Skip checking for already marked inactive uniforms
  let id = shd.get(name)           # Get the location of name
  if id < 0: u.ina = true; return  # Couldn't find it, so mark inactive and skip registration
  assert id >= 0, (&"::ERR -> Trying to register an invalid uniform with id: {id}")
  u.name = name
  u.id   = id.u32  # Uniform values will be in range 0..GL_MAX_UNIFORM_LOCATIONS

#______________________________
# proc enable *(u :Uniforms) :void=
  # for it in u: it.enable

]##


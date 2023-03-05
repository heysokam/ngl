#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# std dependencies
import std/strformat
# ndk dependencies
import nstd/types
import nstd/C
import nmath/types    as m
# Module dependencies
from   ./gl           as gl import nil
import ./types/uniform
import ./types/shader as shdTypes
import ./shader
import ./color


#______________________________
proc newUniform *() :Uniform=  Uniform(kind: Kind.Tnone, name: "EmptyUniform")
  ## Create an empty uniform
#______________________________
proc uniform *[T](val :T) :Uniform=
  when val is i32:   result = Uniform(kind: Kind.Ti32,   i32v:   val)
  elif val is f32:   result = Uniform(kind: Kind.Tf32,   f32v:   val)
  elif val is Vec2:  result = Uniform(kind: Kind.Tvec2,  vec2v:  val)
  elif val is Vec3:  result = Uniform(kind: Kind.Tvec3,  vec3v:  val)
  elif val is Vec4:  result = Uniform(kind: Kind.Tvec4,  vec4v:  val)
  elif val is Color: result = Uniform(kind: Kind.Tcolor, colorv: val)
  elif val is Mat4:  result = Uniform(kind: Kind.Tmat4,  mat4v:  val)
  else:
    echo "::ERR-> Uniform value type is not supported by the uniform constructor"
    result = newUniform()
#______________________________
proc `:=`*(v :var Uniform; val :auto) :void=  v = val.uniform
  ## Assignment operator for Uniforms
  ## Does not work during variable initialization (var, let, const)
  ## Use uniform(val) for initializing values
  ## Does NOT initialize it for OpenGL, will only store the data

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
proc enable *(u :Uniform) :void=
  ## Uploads the Uniform.data to OpenGL
  ## Requires that the uniform.id has been initialized
  if u.ina: return
  case u.kind:
  of   Kind.Tnone:   return
  of   Kind.Ti32:    gl.uniform1iv(u.id, 1, u.i32v.caddr)
  of   Kind.Tf32:    gl.uniform1fv(u.id, 1, u.f32v.caddr)
  of   Kind.Tvec2:   gl.uniform2fv(u.id, 1, u.vec2v.caddr)
  of   Kind.Tvec3:   gl.uniform3fv(u.id, 1, u.vec3v.caddr)
  of   Kind.Tvec4:   gl.uniform4fv(u.id, 1, u.vec4v.caddr)
  of   Kind.Tcolor:  gl.uniform4fv(u.id, 1, u.colorv.caddr)
  of   Kind.Tmat4:   gl.uniformMatrix4fv(u.id, 1, false, u.mat4v.caddr)
#______________________________
# proc enable *(u :Uniforms) :void=
  # for it in u: it.enable

#______________________________
proc newUniform *(val :auto; name :str; shd :ShaderProg; enable :bool= false) :Uniform=
  ## Creates and registers a new uniform
  ## Will populate its id from the given shader and name
  ## The name is expected to exist in the shader
  ## It will not enable it by default, unless enable=true is specified
  # TODO: Error check
  result = val.uniform
  result.register(name, shd)
  if enable: result.enable


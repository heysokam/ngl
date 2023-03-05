#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# External dependencies
import pkg/chroma
# ndk dependencies
import nstd/types
import nmath/types as m
# Module dependencies
import ./base as rTypes


#_______________________________________________________
type Kind *{.pure.}= enum Tnone, Ti32, Tf32, Tvec2, Tvec3, Tvec4, Tcolor, Tmat4
#______________________________
type Uniform * = ref object of OpenGLObj
  ## Uniform Variant type
  case kind*: Kind
  of   Kind.Tnone:  discard
  of   Kind.Ti32:   i32v   *:i32    # Signed integer. Default for numbers
  of   Kind.Tf32:   f32v   *:f32    # Decimal point value. Applied when there is only numbers and one dot
  of   Kind.Tvec2:  vec2v  *:Vec2   # Vector2
  of   Kind.Tvec3:  vec3v  *:Vec3   # Vector3
  of   Kind.Tvec4:  vec4v  *:Vec4   # Vector4
  of   Kind.Tcolor: colorv *:Color  # Normalized rgba value. Missing components: alpha will be 1, colors will be 0
  of   Kind.Tmat4:  mat4v  *:Mat4   # Matrix 4x4
  name  *:str   ## Name of this uniform, as referenced by the shader code
  ina   *:bool  ## Inactive. Marked true when the uniform is not found in shader code
#______________________________
proc data *[T](u :Uniform) :T=
  ## Returns the data that this uniform contains
  case u.kind:
  of   Kind.Tnone:  discard
  of   Kind.Ti32:   result = u.i32v
  of   Kind.Tf32:   result = u.f32v
  of   Kind.Tvec2:  result = u.vec2v
  of   Kind.Tvec3:  result = u.vec3v
  of   Kind.Tvec4:  result = u.vec4v
  of   Kind.Tcolor: result = u.colorv
  of   Kind.Tmat4:  result = u.mat4v
#______________________________
type Uniforms * = seq[Uniform]


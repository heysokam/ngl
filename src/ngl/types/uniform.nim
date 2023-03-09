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
type Kind *{.pure.}= enum
  none   ## Uninitialized
  i32    ## Signed integer. Default for numbers
  f32    ## Decimal point value. Applied when there is only numbers and one dot
  vec2   ## Vector2
  vec3   ## Vector3
  vec4   ## Vector4
  color  ## Normalized Pre-multiplied rgba value. Missing components: alpha will be 1, colors will be 0
  mat4   ## Matrix 4x4
#______________________________
type UniformData * = i32 | f32 | Vec2 | Vec3 | Vec4 | Color | Mat4
  ## Types of data accepted by the Uniform uploading procs
#______________________________
type Uniform * = ref object of OpenGLObj
  ## Uniform Data Connector Slot
  kind  *:Kind  ## Type of data that will be connected through this Uniform. Cannot be typedesc, but should.
  name  *:str   ## Name of this uniform, as referenced by the shader code
  ina   *:bool  ## Inactive. Marked true when the uniform is not found in shader code
#______________________________
type Uniforms * = seq[Uniform]


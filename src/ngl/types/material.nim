#:___________________________________________________
#  ngl  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:___________________________________________________
# External dependencies
from   pkg/chroma import Color
# Module dependencies
import ./texture
import ./uniform


##[
type Mat * = enum
  # Diffuse, Specular, Shininess, Ambient, Emissive,
  Normals, Height, Displacement,
  Lightmap, Reflection
]##

#____________________
type MatType      * = enum Diffuse, Specular, Shininess, Ambient, Emissive
#____________________
type Material * = object
  case kind *:MatType
  of   Diffuse:    Kd  *:Color    ## Diffuse color value
  of   Specular:   Ks  *:float32  ## Specular reflectiveness amount
  of   Shininess:  Ki  *:float32  ## Specular Shininess amount
  of   Ambient:    Ka  *:Color    ## Ambient color value
  of   Emissive:   Ke  *:Color    ## Emissiveness color value
  tex  *:Texture                  ## Material texture, contains a K value for each pixel individually
#____________________
type Materials * = seq[Material]

#____________________
# K Field access alias
proc K *[T](mat :Material) :T=
  ## Returns the K value of the material, according to its type.
  case mat.kind
  of   Diffuse:    result = mat.Kd
  of   Specular:   result = mat.Ks
  of   Shininess:  result = mat.Ki
  of   Ambient:    result = mat.Ka
  of   Emissive:   result = mat.Ke
#____________________
proc `K=` *[T](mat :var Material; val :T) :void=
  ## Assigns `val` to the corresponding Kx field of the material, according to its type.
  case mat.kind
  of Diffuse:
    when T is Color:   mat.Kd = val
  of Specular:
    when T is float32: mat.Ks = val
  of Shininess:
    when T is float32: mat.Ki = val
  of Ambient:
    when T is Color:   mat.Ka = val
  of Emissive:
    when T is Color:   mat.Ke = val


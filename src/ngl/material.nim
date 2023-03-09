#:___________________________________________________
#  ngl  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:___________________________________________________
# Module dependencies
import ./types/texture  as texType
import ./types/material as matType
import ./texture
import ./uniform


proc newMaterial *(typ :MatType; tex :Texture= newTexture(); K :SomeNumber= 1) :Material=
  Material(typ: typ, tex: tex, K: K.uniform)

template valid(mat :Material) :bool= mat.tex.valid()


#____________________
proc register *(mat :Material) :void=
  if not mat.valid:           return
  if not mat.tex.registered:  mat.tex.register()
#____________________
proc register *(mats :Materials) :void=
  for mat in mats:  mat.register




##[
#____________________
type MatType      * = enum Diffuse, Specular
#____________________
type Material * = object
  typ  *:MatType  ## Material type
  tex  *:Texture  ## Material texture, contains a K value for each pixel individually
  K    *:Uniform  ## Value property of the material, applied to the texture uniformly
]##


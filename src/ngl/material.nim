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

#____________________
# types/render.nim -> material
#____________________
import ../texture
#____________________
# PBR and Packing:
#   MRAO          :(RGB) +A   (why white?)
#   Emissive      :?
#   Normal+Height :RGBA
#   https://docs.momentum-mod.org/shader/physically-based-rendering/
# TODO: Emissive, Reflective, Metalic, AO
type MatKind *{.pure.}= enum None, Dif, Spe, Amb
type Mat * = object
  id    *:u32      ## id number. Will be combined with the name
  name  *:str      ## Will be combined with the id (eg: Diffuse0)
  kind  *:MatKind  ## Type of material
  val   *:Color    ## Color value. Single component materials will be stored at val.r
  tex   *:Texture  ## Texture image
#_______________________________________________________
proc newMaterial *() :Mat=
  ## Create an empty material
  Mat(id: 0, name: "EmptyMaterial", kind: MatKind.None, val: color(0,0,0,1), tex: newTexture())
#_______________________________________________________
proc mat *(tex :Texture; color :Color; id :u32; kind :MatKind) :Mat=
  var name :str
  case kind
  of   MatKind.None: name = "EmptyMaterial"
  of   MatKind.Dif:  name = "Diffuse"
  of   MatKind.Spe:  name = "Specular"
  of   MatKind.Amb:  name = "Ambient"
  result = Mat(id: id, kind: kind, val: color, tex: tex, name: name)
#_______________________________________________________
proc mat *(color :Color; id :u32) :Mat=
  ## Creates a new material from the color value
  ## Defaults to Ambient, since its the only type that can contain color as its only property
  Mat(id: id, name: "Ambient", kind: MatKind.Amb, val: color, tex: newTexture())
#_______________________________________________________

]##


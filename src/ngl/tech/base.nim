#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# std dependencies
import std/sequtils
import std/strformat
# ndk dependencies
import nstd/types  as base
import nmath/types as mTypes
# Module dependencies
import ../logger
from   ../gl       as gl import nil
import ../shader
import ../uniform
import ../color
import ../types    as rTypes
import ./types

#____________________
proc newRenderPhase *() :RenderPhase=  RenderPhase(name: "EmptyPhase", vert: "", frag: "", shd: newShaderProg())
  ## Creates a new empty render phase
#____________________
proc newRenderPhase *(name, vert, frag :str; init :bool= false) :RenderPhase=
  ## Creates a new rendering technique with the given data
  ## Doesn't initialize the shader by default. Can be changed with init = true
  RenderPhase(name: name, vert: vert, frag: frag, shd: if init: newShaderProg(vert, frag) else: newShaderProg())
#____________________
proc init *(phs :var RenderPhase) :void=
  ## Initializes the shader program of the given RenderPhase
  ## Does not allow reinit without calling RenderPhase.term first
  if phs.act: return  # Skip initializing twice
  log &"Initializing shaders of RenderPhase: {phs.name}"
  phs.shd = newShaderProg(phs.vert, phs.frag)
  phs.act = true
#____________________
proc term *(phs :var RenderPhase) :void=
  ## Terminates the shader program of the given RenderPhase
  phs.shd.term
  phs.act = false
  log &"Terminated shaders of RenderPhase: {phs.name}"
#____________________
proc enable *(phs :RenderPhase) :void=
  ## Enables the shader program of the given RenderPhase
  gl.useProgram(phs.shd.id)


#____________________
func newRenderTech *() :RenderTech=  RenderTech(name: "EmptyTechnique", phase: @[], uniforms: @[])
  ## Creates a new empty rendering technique
#____________________
func newRenderTech *(name :str; phs :RenderPhases) :RenderTech=  RenderTech(name: name, phase: phs)
  ## Creates a new rendering technique with the given data
#____________________
func act *(rt :RenderTech) :bool=
  ## Returns true if all phases in this technique are active
  if rt.phase.allIt(it.act): true else: false
#____________________
proc init *(rt :var RenderTech; phaseId :u8) :void=  rt.phase[phaseId].init
  ## Initializes a specific phase for the given Rendering Technique, based on its contained vert/frag file paths
#____________________
proc init *(rt :var RenderTech) :void=
  ## Initializes all shaders of the given Rendering Technique, based on their contained vert/frag file paths
  for phase in rt.phase.mitems:  phase.init
#____________________
proc term *(rt :var RenderTech) :void=
  ## Terminates all programs of the given Rendering Technique
  for phase in rt.phase.mitems:  phase.term
#____________________
proc enable *(rt :var RenderTech; phaseId :SomeUnsignedInt) :void=
  ## Enables the shader program of the given phaseId, contained in the given Rendering Technique
  if not rt.phase[phaseId].act:  rt.phase[phaseId].init
  rt.phase[phaseId].enable
#____________________
proc enable *(rt :var RenderTech; mvp :Mat4) :void=
  ## Enables all phases of the the target Render Technique
  ## Initializes any of the phases that have not been init yet
  if not rt.act: rt.init()
  for uni in rt.uniforms:  uni.enable()  # Enable all uniforms
#____________________
proc get *(rt :RenderTech; attr :str; phaseId :SomeUnsignedInt) :cint=
  ## Returns the attribute uniform id number of the specified technique phase
  rt.phase[phaseId.int].shd.get(attr)






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



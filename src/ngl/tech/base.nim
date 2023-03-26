#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# std dependencies
import std/strformat
# Library dependencies
import ../types/core as rTypes
import ../types/error
import ../types/tech
import ../types/body
# Module dependencies
import ./simple/pass as simple


#____________________
proc apply *(r :Renderer; pass :RenderPass; mesh :RenderMesh) :void=
  ## Enables the shader program of the given RenderPass
  case pass.name
  of   Pass.Simple:
    simple.enable(pass)
    simple.apply(r, pass, mesh)
    simple.disable(pass)
  else: raise newException(GLError, &"Application of {pass.name} has not been implemented. Use a custom procedure if its a custom Pass type.")

#____________________
proc apply *(r :Renderer; phs :RenderPhase; mesh :RenderMesh) :void=
  ## Applies all Render Passes of the given RenderPhase, using the given mesh.
  for pass in phs.pass:
    r.apply(pass, mesh)


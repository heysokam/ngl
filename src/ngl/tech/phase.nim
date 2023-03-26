#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# std dependencies
import std/strformat
# Library dependencies
import ../types/error
# Module dependencies
import ../types/tech
import ./pass
import ./simple/phase as simple

#_____________________________
# Constructors
#___________________
proc new *(phs :Phase) :RenderPhases=
  case  phs
  of    Phase.SimpleDraw: @[ newSimpleDraw() ]
  else: raise newException(GLError, &"Object creation for {phs} has not been implemented. Use a custom constructor if its a custom Phase type.")

#_____________________________
# Enable Phases
#___________________
proc enable *(phs :RenderPhase) :void=
  ## Runs the process in the given RenderPhase, using the currently bound buffers.
  case  phs.name
  of    Phase.SimpleDraw: simple.enable(phs)
  else: raise newException(GLError, &"Application of {phs.name} has not been implemented. Use a custom drawing function if its a custom Phase type.")


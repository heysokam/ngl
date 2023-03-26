#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# Library dependencies
import ../../types/tech
import ../../types/body
# Module dependencies
import ../base
import ../pass
import ./pass as simple

#_____________________________
# Constructor
#___________________
proc newSimpleDraw *() :RenderPhase=
  RenderPhase(name: Phase.SimpleDraw, pass: Pass.Simple.new())

#_____________________________
# Enable Phase
#___________________
proc enable *(phs :RenderPhase) :void=
  simple.enable(phs.pass[0])


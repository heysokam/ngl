#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# Module dependencies
import ../../types/tech
import ../phase


#_____________________________
proc newSimpleTech *() :RenderTech=
  ## Creates a new Tech.Simple object.
  ## Used for drawing the Hello Triangle example.
  result.name  = Tech.Simple
  result.phase = Phase.SimpleDraw.new()


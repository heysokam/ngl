#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# std dependencies
import std/strformat
# Library dependencies
import ../types/error
# Module dependencies
import ../types/tech
import ./simple/pass as simple


#_____________________________
# Constructors
#___________________
proc new *(pass :Pass) :RenderPasses=
  case  pass
  of    Pass.Simple: @[ newSimplePass() ]
  else: raise newException(GLError, &"Object creation for {pass} has not been implemented. Use a custom constructor if its a custom Pass type.")

#_____________________________
# Enable Passes
#___________________
proc enable *(pass :RenderPass) :void=
  case  pass.name
  of    Pass.Simple: simple.enable(pass)
  else: raise newException(GLError, &"Application of {pass.name} has not been implemented. Use a custom drawing function if its a custom Pass type.")


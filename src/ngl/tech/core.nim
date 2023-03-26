#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# std dependencies
import std/strformat
# Library dependencies
import ../types/error
# Module dependencies
import ../types/tech
import ./simple/tech as simple


#_____________________________
# Constructors
#___________________
proc new *(t :Tech) :RenderTechs=
  ## Creates a new RenderTech object, based on the given Tech kind.
  case  t
  of    Tech.None:    @[ RenderTech(name: t, phase: @[]) ]
  of    Tech.Simple:  @[ newSimpleTech() ]
  else: raise newException(GLError, &"Object creation for {t} has not been implemented. Use a custom constructor if its a custom Tech type.")


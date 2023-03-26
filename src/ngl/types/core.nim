#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# External dependencies
from   pkg/chroma import Color
# Module dependencies
import ./window
import ./camera
import ./profile
import ./tech


#____________________
type Renderer * = ref object of RootObj
  win      *:Window
  cam      *:Camera
  bg       *:Color
  profile  *:RenderProfile
  tech     *:RenderTechs


#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# External dependencies
from staticglfw as glfw import nil
# ndk dependencies
import nstd/types  as base
import nmath/types as m


#____________________
type Window * = ref object of RootObj
  ct       *:glfw.Window
  size     *:Size
  title    *:str



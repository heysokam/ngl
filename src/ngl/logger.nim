#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# ndk dependencies
import nstd/logger

#____________________
# State
#____________________
var log *:LogFunc= noLog
proc setLogger *(p :LogFunc) :void=  log = p
  ## Assigns the given proc as the logger function of this lib.
  ## This proc is stored in the internal state of the lib, 
  ## and called when OpenGL sends a callback event.


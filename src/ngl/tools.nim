#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# ndk dependencies
import nstd/types
import nstd/time


#____________________
proc fpsUpdate *(timeCurr :Time; updLimit :var Duration; minimum, tickrate :Duration) :tuple=
  ## Updates the state of the current frameRate and frameTime values
  ## based on the total time spent on this frame
  ## frameRate will only be updated if frameTime is over the minimum
  ## e.g. update only 4x per sec:    if updLimit > 0.25
  ## Returns: (frameTime, frameDiff, timePrev, frameRate)
  let diff = time.get() - timeCurr
  updLimit += diff
  var timePrev  :Time
  var frameRate :u64
  if updLimit > minimum:
    frameRate = (1 / diff.toSec).u64
    updLimit  = initDuration()
    timePrev  = timeCurr  # Store timeCurr as the next step's timePrev
  let frameTime = diff
  let frameDiff = tickrate - frameTime
  result = (frameTime, frameDiff, timePrev, frameRate)

#____________________
proc sshot *()= discard
  # TODO: use glGetTextureImage
  # https://registry.khronos.org/OpenGL-Refpages/gl4/html/glGetTexImage.xhtml

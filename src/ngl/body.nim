#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# ndk dependencies
import nmath/types as m
import nmath/trf
# Module dependencies
import ./types

#____________________
proc newRenderBody *[T]() :RenderBody[T]=  RenderBody[T]()
proc newRenderBody *[T](mdl :RenderModel; trf :Transform[T]) :RenderBody[T]=
  ## Creates a new RenderBody object from the given data
  ## Defaults when ommited: 
  ##   Empty sequence as its RenderModel
  ##   Empty Transform, with every value at 0
  RenderBody[T](mdl: mdl, trf: trf)


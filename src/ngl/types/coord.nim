#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________


#______________________________
type Axis * = object
  pos *:int8
  neg *:int8
#____________________
type Coords * = object
  X *:Axis
  Y *:Axis
  Z *:Axis


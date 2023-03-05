#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________


#_______________________________________
type ShaderType * = enum Vert, Frag, Comp
  ## Type of shader. Name will be normalized and used as extension.  (eg: Frag will be .frag)


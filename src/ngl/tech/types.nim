#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# ndk dependencies
import nstd/types as base
# Module dependencies
import ../types

#:______________________________________________________________________
## Phase:
##   Particular stage or point in a recurring sequence of movement or changes
##   Each step of the sequence is introduced gradually as a separate stage of the process
#____________________
## Technique
##   Details related to the expression of a skill, craft or art style
##   In rendering: Details related to a specific Rendering Style
#____________________
## RenderPhase
##   Particular step/stage in a rendering technique sequence
#:______________________________________________________________________

#____________________
type RenderPhase  * = object
  ## Data related to executing a single phase/step of a rendering technique
  name  *:str         ## Name of the phase
  vert  *:str         ## Vertex   shader file
  frag  *:str         ## Fragment shader file
  act   *:bool        ## Active/Inactive : True when the technique shaders can be used in OpenGL (init/term)
  shd   *:ShaderProg  ## Shader program used to generate this phase, using vert/frag files
#____________________
type RenderPhases * = seq[RenderPhase]  ## Contains all phases of a certain rendering technique

#____________________
type RenderTech * = object
  ## Data related to executing a specific Rendering Technique
  name     *:str           ## Name of the technique. Should be identifiable, for when its used for debugging/logging
  phase    *:RenderPhases  ## Sequence of phases that this technique will execute
  uniforms *:Uniforms      ## Sequence of uniform data objects that the technique will use


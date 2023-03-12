#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# ndk dependencies
import nstd/types as base
# Module dependencies
import ../types

#_______________________________________
## Render Technique: Details related to acheiveing a specific Rendering Style
## Render Phase:     Particular step/stage in a rendering technique sequence
## Render Pass:      Individual step in a rendering Phase. (many objects)
## Render Call:      Individual order to the GPU to draw something.  (one or many objects)
## See `doc/tech.md` for a more detailed explanation.
#_______________________________________


type RenderPass * = object
#____________________
type RenderPhase  * = object
  ## Data related to executing a single phase/step of a rendering technique
  name  *:str         ## Name of the phase
  act   *:bool        ## Active/Inactive : True when the technique shaders can be used in OpenGL (init/term)
  shd   *:ShaderProg  ## Shader program used to generate this phase, using vert/frag files
#____________________
type RenderPhases * = seq[RenderPhase]  ## Contains all phases of a certain rendering technique

#____________________
type RenderTech * = object
  ## Data related to executing a specific Rendering Technique
  name     *:str           ## Name of the technique. Should be identifiable, for when its used for debugging/logging
  phase    *:RenderPhases  ## Sequence of phases that this technique will execute

##[
RenderTech    # Made of Phases
RenderPhase   # Made of Passes
RenderPass    # Made of calls
]##



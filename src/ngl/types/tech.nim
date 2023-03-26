#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# ndk dependencies
import nstd/types as base
# Module dependencies
import ./shader

#_______________________________________
## Render Technique: Details related to acheiveing a specific Rendering Style
## Render Phase:     Particular step/stage in a rendering technique sequence
## Render Pass:      Individual step in a rendering Phase. (many objects)
## Render Call:      Individual order to the GPU to draw something.  (one or many objects)
## See `doc/tech.md` for a more detailed explanation.
#_______________________________________


#_____________________________
type Pass *{.pure.}= enum
  None     ## Nothing is drawn
  Simple   ## Simplest possible pass. Draw position with flat color, no lights and no textures (eg: Hello Triangle)
#____________________
type RenderPass * = object
  ## Individual step in a rendering Phase.
  ## Draws all objects or data with the defined Shader Program.
  ## Examples: Bloom pass, Deferred Light Shading pass, G-Buffer generation pass with MRT.
  name  *:Pass        ## Name of the Pass. Identifier for debugging/logging
  shd   *:ShaderProg  ## Shader program used to generate this pass
#____________________
type RenderPasses * = seq[RenderPass]


#_____________________________
type Phase *{.pure}= enum
  None        ## Nothing is drawn. eg: Hello Window Clear example.
  SimpleDraw  ## Simplest possible Phase. Hardcoded shader, one pass without processing. eg. Hello Triangle example.
#____________________
type RenderPhase  * = object
  ## Data related to executing a single phase/step of a rendering technique.
  ## Examples: G-Buffer phase, Shading phase, Post-Processing phase.
  name  *:Phase         ## Name of the Phase. Identifier for debugging/logging
  pass  *:RenderPasses  ## Passes required to execute this phase.
#____________________
type RenderPhases * = seq[RenderPhase]  ## Contains all phases of a certain rendering technique


#_____________________________
type Tech *{.pure.}= enum
  None      ## Nothing is drawn. eg: Hello Window Clear example.
  Simple    ## Simplest possible tech. Hardcoded shader, one pass without processing. eg. Hello Triangle example.
  # Custom  #todo: ## Custom made Tech. Uses function callbacks to draw.
#____________________
type RenderTech * = object
  ## Data related to executing a specific Rendering Technique.
  ## Examples: Deferred Rendering with bloom and cel-shading Post-Processing effects.
  ##           Would contain >> G-buffer phase, shading phase, bloom phase and cel-shading phase.
  name   *:Tech          ## Name of the technique. Identifier for debugging/logging
  phase  *:RenderPhases  ## Sequence of phases that this technique will execute
#____________________
type RenderTechs * = seq[RenderTech]


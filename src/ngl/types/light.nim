#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# External dependencies
import pkg/chroma
# ndk dependencies
import nstd/types
import nmath/types as m
# Module dependencies
import ./uniform

#____________________
type LightFlag  *{.pure.}= enum 
  ina  ## Active Light. Will be rendered.
  stt  ## Static light. Cannot move or change properties
type LightFlags * = set[LightFlag]
#____________________
type LightKind  *{.pure.}= enum 
  Amb   ## Ambient light
  Dir   ## Directional Light  (sun)
  Pt    ## Point Light. Omnidirectional
  Spot  ## Directional Light with a position  (spotLight)
#____________________
type Light * = object
  ## Variant type for all light styles
  case kind*: LightKind
  of   LightKind.Amb:  discard
  of   LightKind.Dir:  dirv  *:Vec3
  of   LightKind.Pt :
    posv  *:Vec3
    foff  *:f32
  of   LightKind.Spot:
    sposv  *:Vec3
    sdirv  *:Vec3
    sfoff  *:f32
  flags  *:LightFlags
  power  *:f32
  color  *:Color
type Lights * = seq[Light]

#______________________________
## TODO:
## Should be unified with the Light type
type LightUniform * = object
  name   *:str     ## Name of the uniform struct that will contain all other uniforms
  active *:bool    ## Whether the light is active or not
  power  *:Uniform ## f32
  color  *:Uniform ## color
  pos    *:Uniform ## vec3
  dir    *:Uniform ## vec3
#______________________________


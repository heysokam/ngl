#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# External dependencies
import pkg/chroma
# ndk dependencies
import nstd/types
import nmath/types as m
# Module dependencies
import ./buffer

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
  of   LightKind.Dir:
    ddir  *:Vec3
  of   LightKind.Pt:
    ppos   *:Vec3
    pfoff  *:f32
  of   LightKind.Spot:
    spos   *:Vec3
    sdir   *:Vec3
    sfoff  *:f32
  flags  *:LightFlags
  power  *:f32
  color  *:Color
  active *:bool    ## Whether the light is active or not
  name   *:str
#____________________
type Lights * = UBO[Light]

#____________________
# Field Aliases
template pos *(l :Light) :Vec3=
  case  l.kind
  of    LightKind.Pt:   l.ppos
  of    LightKind.Spot: l.spos
  else: vec3(0,0,0)
template dir *(l :Light) :Vec3=
  case  l.kind
  of    LightKind.Dir:  l.ddir
  of    LightKind.Spot: l.sdir
  else: vec3(0,0,0)
template foff *(l :Light) :f32=
  case  l.kind
  of    LightKind.Pt:   l.pfoff
  of    LightKind.Spot: l.sfoff
  else: 0.0'f32
#____________________
template `pos=` *(l :var Light; val :Vec3) :void=
  case  l.kind
  of    LightKind.Pt:   l.ppos = val
  of    LightKind.Spot: l.spos = val
  else: discard
template `dir=` *(l :var Light; val :Vec3) :void=
  case  l.kind
  of    LightKind.Dir:  l.ddir = val
  of    LightKind.Spot: l.sdir = val
  else: discard
template `foff=` *(l :var Light; val :f32) :void=
  case  l.kind
  of    LightKind.Pt:   l.pfoff = val
  of    LightKind.Spot: l.sfoff = val
  else: discard


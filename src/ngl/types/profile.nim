#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# ndk dependencies
import nstd/types as base

#____________________
type RenderVers * = object
  major  *:u8
  minor  *:u8
type RenderProfile * = object
  id     *:u8
  name   *:str
  vers   *:RenderVers

# Profile Presets
const glFour * = RenderProfile(id: 0, name: "OpenGL Latest",       vers: RenderVers(major:4, minor:6))
const glCore * = RenderProfile(id: 1, name: "OpenGL Core",         vers: RenderVers(major:3, minor:5))
const glFFP  * = RenderProfile(id: 2, name: "OpenGL Legacy (FFP)", vers: RenderVers(major:1, minor:3))


# ndk dependencies
import nstd/time
import nmath
import ngl

#____________________
# General Config
const maxDelta   *:Duration=  initDuration(milliseconds = 1000 div 4)

#____________________
# Rendering
const res         * = uvec2(1366, 768)  ## Default window resolution the engine will launch with
const renderProf  * = glFour            ## OpenGL Rendering profile that will be loaded. Must be latest. Compat support is not planned.
const coordSystem * = OpenGLCoords      ## Right handed, -Z down, +Y forw, -X left
const resizable   * = false             ## Whether the engine's window is resizable by default or not
const vsync       * = false             ## Whether to have vsync active by default or not
const cam         * = newCamera(
  origin = vec3(40,120,40),
  target = vec3(0,0,0),
  up     = vec3(0,1,0),
  fov    = 45.0,
  near   = 0.1,
  far    = 10000.0)


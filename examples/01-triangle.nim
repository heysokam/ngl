#:___________________________________________________
#  ngl  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:___________________________________________________
# ndk dependencies
import nstd
import nmath
import ngl
import ngl/gl/tools as gl
# Module dependencies
import ./cfg
import ./todo

#__________________________________________________
# Triangle
const pos = @[
  vec3(-0.5, -0.5, 0.0), # left  
  vec3( 0.5, -0.5, 0.0), # right 
  vec3( 0.0,  0.5, 0.0)  # top   
]
const inds = @[uvec3( 0, 1, 2 )] # CCW Winding order (left,right,top). One triangle, one uvec3 ind

#__________________________________________________
# State
var render    :Renderer
var triangle  :RenderMesh

#__________________________________________________
# Entry point
#____________________
proc run=
  # Start
  let name = "Triangle"
  echo "Hello ",name
  render.init(cfg.cam, cfg.res.x, cfg.res.y, name, cfg.resizable, cfg.vsync)
  render.tech = Tech.Triangle.new()
  triangle = newRenderMesh(pos,inds)
  triangle.register()

  # Update loop
  while not render.win.exit(): 
    gl.clear()                     # Clear the screen, using OpenGL alias from ngl/gl/tools
    triangle.draw(render.tech[0])  # Draw the triangle
    render.win.update()            # Update screen


  # Stop
  render.win.term()
#____________________
when isMainModule: run()


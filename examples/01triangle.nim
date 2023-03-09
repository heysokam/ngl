#:___________________________________________________
#  ngl  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:___________________________________________________
# ndk dependencies
import nstd/types as base
import nstd/time
import nmath
import ngl
import ngl/gl/tools as gl
# Module dependencies
import ./cfg
import ./todo


#__________________________________________________
# Triangle
const vert :str= """
#version 460 core
layout (location = 0) in vec3 aPos;
void main() { gl_Position = vec4(aPos, 1.0); }
"""
const frag :str= """
#version 460 core
out vec4 fColor;
void main() { fColor = vec4(1.0, 0.5, 0.0, 1.0); }
"""
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
  render.init(cfg.cam, cfg.res.x, cfg.res.y, name, cfg.resizable, cfg.vsync, cfg.renderProf)
  triangle = newRenderMesh(pos,inds, shader = newShaderProgCode(vert, frag))
  triangle.register()

  # Update loop
  while not render.win.exit(): 
    gl.clear()              # Clear the screen
    triangle.draw()         # Draw the triangle
    render.win.update()     # Update screen

  # Stop
  render.win.term()

#____________________
when isMainModule: run()


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


#__________________________________________________
# State
var render    :Renderer

#__________________________________________________
proc run=
  let name = "Clear Screen"
  echo "Hello ",name
  render.init(cfg.cam, cfg.res.x, cfg.res.y, name, cfg.resizable, cfg.vsync, cfg.renderProf)
  while not render.win.exit(): 
    gl.clear()          # Clear the screen, using OpenGL alias from ngl/gl/tools
    render.win.update()
  render.win.term()
#____________________
when isMainModule: run()

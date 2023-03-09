#:___________________________________________________
#  ngl  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:___________________________________________________
# std dependencies
import std/strformat
# External dependencies
import pkg/chroma
from   pkg/staticglfw as glfw import nil
# ndk dependencies
import nstd/types as base
import nmath
import ngl/types
import ngl/gl as gl
# Module dependencies
import ./cfg


#__________________________________________________
# State
var render  :Renderer

#__________________________________________________
# Run
proc start()=   # render.init(...)
  let name = "Clear Screen"
  echo "Hello ",name
  #_______________________________________
  # Initialize the Renderer object
  #   render = newRenderer(...)
  render     = Renderer(
    win:     Window(ct: nil, size: cfg.res, title: name),
    cam:     Camera( pos: cfg.cam.pos,  rot:  cfg.cam.rot,   up:  cfg.cam.up, 
                     fov: cfg.cam.fov,  near: cfg.cam.near,  far: cfg.cam.far  ),
    bg:      color(0, 0, 0, 1),
    profile: cfg.renderProf
    )
  #_______________________________________
  # Initialize the Window config
  #   render.win = w.init(...)
  assert glfw.init().bool
  glfw.windowHint(glfw.ContextVersionMajor, render.profile.vers.major.cint)
  glfw.windowHint(glfw.ContextVersionMinor, render.profile.vers.minor.cint)
  glfw.windowHint(glfw.OpenglProfile, glfw.OpenglCoreProfile)
  glfw.windowHint(glfw.OpenglForwardCompat, glfw.True) # Removes deprecated functions. Required for Mac, but we use it for all.
  glfw.windowHint(glfw.Resizable, if cfg.resizable: glfw.True else: glfw.False)
  # Initialize the Window object
  render.win.ct    = glfw.createWindow(cfg.res.x.cint, cfg.res.y.cint, cfg.name.cstring, nil, nil)
  assert render.win.ct != nil, "Failed to create GLFW window"
  render.win.size  = uvec2(cfg.res.x, cfg.res.y)
  render.win.title = name
  # Set the window callbacks
  discard glfw.setKeyCallback(render.win.ct, nil)
  discard glfw.setCursorPosCallback(render.win.ct, nil)
  discard glfw.setMouseButtonCallback(render.win.ct, nil)
  discard glfw.setScrollCallback(render.win.ct, nil)
  discard glfw.setFramebufferSizeCallback(render.win.ct, nil)  # Set viewport size/resize callback
  # Make it active
  glfw.makeContextCurrent(render.win.ct)
  # Update GLFW window config
  glfw.swapInterval(cfg.vsync)

  #_______________________________________
  # Initialize OpenGL
  gl.init()                               # Load OpenGL context
  #   render.win.ct.resize(...)
  gl.viewport(0,0, cfg.res.x.int32, cfg.res.y.int32)  # Set the initial viewport position and size
  #_______________________________________
  # Initialize OpenGL Config
  gl.setDebug()  # Enable OpenGL debugging
  gl.setBlend()  # Set OpenGL blending mode
  gl.setCull()   # Set OpenGL face culling mode
  gl.setDepth()  # Set OpenGL depth test
  #_______________________________________
  # Report Initialized data to console
  echo &"Initialized {render.profile.name}: {$render.profile.vers.major.int32}.{$render.profile.vers.minor.int32}"


proc exit() :bool=
  # render.win.exit()
  glfw.windowShouldClose(render.win.ct).bool

proc loop()=
  # render.win.update()
  gl.clear()                       # Clear the screen
  glfw.swapBuffers(render.win.ct)  # Update the window screen

proc stop()=
  # render.win.term()
  glfw.destroyWindow(render.win.ct)
  glfw.terminate()

#__________________________________________________
when isMainModule:
  start()
  while not exit(): loop()
  stop()


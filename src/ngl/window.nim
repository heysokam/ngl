#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# std dependencies
import std/strformat
# External dependencies
from pkg/staticglfw as glfw import nil
# ndk dependencies
import nstd/types as base
import nstd/auto
import nmath
# Module dependencies
import ./types
from   ./gl    as gl import nil

#____________________
# probably part of ./window/events.nim
proc resize *(w :glfw.Window; W,H :i32) :void {.cdecl, discardable.} =
  ## GLFW FrameBuffer resize callback
  gl.viewport(0,0, W, H)
#____________________
proc error *(code :i32; desc :cstring) :void {.cdecl, discardable.} =
  ## GLFW error callback
  stderr.write(&"Error:{code} {desc}\n")
  gl.log $desc
#____________________
proc init *(width, height :u32; title :str; 
            resizable, vsync :bool; prof :RenderProfile,
            key :glfw.KeyFun; mousePos :glfw.CursorPosFun; mouseBtn :glfw.MouseButtonFun; mouseScroll :glfw.ScrollFun
            ) :Window=
  ## Initializes the a Window object with the given data, and returns it.
  gl.log &"Starting GLFW: {$glfw.getVersionString()}"
  # Initialize GLFW
  discard glfw.setErrorCallback(error)
  assert glfw.init().bool
  glfw.windowHint(glfw.ContextVersionMajor, prof.vers.major.cint)
  glfw.windowHint(glfw.ContextVersionMinor, prof.vers.minor.cint)
  glfw.windowHint(glfw.OpenglProfile, glfw.OpenglCoreProfile)
  glfw.windowHint(glfw.OpenglForwardCompat, glfw.True) # Removes deprecated functions. Required for Mac, but we use it for all.
  glfw.windowHint(glfw.Resizable, if resizable: glfw.True else: glfw.False)
  # Initialize the Window object
  new result
  result.ct    = glfw.createWindow(width.cint, height.cint, title.cstring, nil, nil)
  assert result.ct != nil, "Failed to create GLFW window"
  result.size  = uvec2(width, height)
  result.title = title
  # Set the window callbacks
  discard glfw.setKeyCallback(result.ct, key)
  discard glfw.setCursorPosCallback(result.ct, mousePos)
  discard glfw.setMouseButtonCallback(result.ct, mouseBtn)
  discard glfw.setScrollCallback(result.ct, mouseScroll)
  discard glfw.setFramebufferSizeCallback(result.ct, resize)  # Set viewport size/resize callback
  # Make it active
  glfw.makeContextCurrent(result.ct)
  # Update GLFW window config
  glfw.swapInterval(vsync)
#____________________
proc update *(w :Window) :void=
  ## Executes the window update loop
  glfw.swapBuffers(w.ct)
#____________________
proc term *(w :Window) :void=
  glfw.destroyWindow(w.ct)
  glfw.terminate()
#____________________
proc exit *(win :glfw.Window) :bool=  glfw.windowShouldClose(win).bool
  ## Returns true if the given window has been marked for closing.

#____________________
func ratio *(w :Window) :f32=  w.size.x.float32/w.size.y.float32
#____________________


#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# std dependencies
import std/strformat
import std/os
# External dependencies
from   pkg/staticglfw as glfw import nil
# ndk dependencies
import nstd/types  as base
import nstd/format
import nstd/logger as nLogger
import nmath/types as mTypes
import nmath       as m
# Module dependencies
from   ./gl        as gl import nil
import ./types
# import ./logger
import ./render    as r
import ./color
import ./buffer
import ./window    as w
import ./camera    as cam
import ./body      as body
import ./texture   as tex
import ./shader    as shd
import ./tech      as tech
import ./light     as light
import ./tools     as rt
import ./logger
import ./C

#__________________________________________________
# Renderer: Initialize
#____________________
proc init *(render :var Renderer; camera :Camera;
            width, height :u32; title :str; resizable, vsync :bool; prof :RenderProfile= glFour;
            key :glfw.KeyFun= nil; mousePos :glfw.CursorPosFun= nil; mouseBtn :glfw.MouseButtonFun= nil; mouseScroll :glfw.ScrollFun= nil;
            log :LogFunc= logger.log;
            ) :void=
  ## Initializes the given Renderer's state.
  lineSep()
  log "Initializing: Renderer"
  render   = newRenderer(prof)
  # Initialize the camera
  render.cam  = camera
  render.win  = w.init(width, height, title, resizable, vsync, prof, key, mousePos, mouseBtn, mouseScroll)
  render.tech = newSeqOfCap[RenderTech](1)
  gl.init()  # Load OpenGL context
  w.resize(render.win.ct, width.i32, height.i32)  # Set the initial viewport position and size

  gl.setDebug()  # Enable OpenGL debugging
  gl.setBlend()  # Set OpenGL blending mode
  gl.setCull()   # Set OpenGL face culling mode
  gl.setDepth()  # Set OpenGL depth test

  log &"Initialized {render.profile.name}: {$render.profile.vers.major.i32}.{$render.profile.vers.minor.i32}"
  # logGLparms()

#__________________________________________________
# Renderer: Draw
#____________________
proc draw *(r :Renderer; mesh :RenderMesh; tech :RenderTech) :void=
  ## Simple draw the given mesh, without any transformation.
  mesh.vao.enable()       # Define what will be rendered (VAO)
  for phs in tech.phase:  # For every phase in the given Technique
    r.apply(phs, mesh)    # Render the mesh
  mesh.vao.disable()      # Clean OpenGL state for the mesh, without deleting the object data from GPU.


proc draw (r :Renderer; mesh :RenderMesh; tech :var RenderTech; view, proj :var Mat4) :void=
  discard

#____________________
proc draw *(r :Renderer; body :RenderBody; tech :var RenderTech; view, proj :var Mat4) :void=
  ## Draws every mesh of the given body with the given Renderer, using the corresponding RenderTech
  if body.mdl.len == 0: return  # Allow passing empty bodies. Just skip drawing them.
  # Draw every mesh of the body
  for mesh in body.mdl: r.draw(mesh, tech, body.world, view, proj)


##[
#__________________________________________________
# TODO: Fix mess, old temp behavior
#____________________
proc draw (r :Renderer; mesh :RenderMesh; tech :var RenderTech; view, proj :var Mat4) :void=
  # Define how data will be rendered (Technique: program and uniforms)
  let phase = 0
  tech.enable(phase)

  #_________________________
  # Uniforms
  let uWVP   = tech.get("uWVP",     phase)
  gl.uniformMatrix4fv(uWVP, 1, false, WVP.caddr)  # transpose: false = Column major matrix   : OpenGL matrices are ColumnMajor

  # Create the color uniform effect  TODO: Remove
  var color = color(0.3, 1, 0.3, 1)
  color.g *= ((sin(glfw.getTime()) / 2.0) + 0.5)  # change over time
  # Color Uniform
  let uColor = tech.get("uColor", phase)
  gl.uniform4fv(uColor, 1, color.caddr)

  #_________________________
  # Texture   TODO: Should be mat
  mesh.tex.enable(0)
  let uDif = tech.get("uDif",    phase)
  gl.uniform1i(uDif, 0)  # Enable TextureUnit 0
  #_________________________
  # Material
  let uMatAmb  = tech.get("uMatAmb", phase)
  var ambColor = color(1,1,1,1)
  gl.uniform4fv(uMatAmb, 1, ambColor.caddr)
  #_________________________
  let uMatDif  = tech.get("uMatDif", phase)
  var difColor = color(1,1,1,1)
  gl.uniform4fv(uMatDif, 1, difColor.caddr)
  #_________________________
  let uMatSpe  = tech.get("uMatSpe", phase)
  var speColor = color(1,1,1,1)
  gl.uniform4fv(uMatSpe, 1, speColor.caddr)

  #_________________________
  # Lights
  var lightAmb = newLight(
    name = "uLightAmb",
    color = color(1,1,1,1), power = 0.1, active = true,
    enable = true, register = true, shd = tech.phase[0].shd); discard lightAmb
  #_________________________
  var lightDir = newLight(
    name   = "uLightDir",
    color  = color(1,1,1,1), power = 1, active = true,
    dir    = model.inverse * vec3(1,-0.5,0),
    enable = true, register = true, shd = tech.phase[0].shd); discard lightDir
  #_________________________

  # Define what will be rendered (VAO)
  mesh.vao.enable()  # VBO and EBO buffers only need binding if they change format
  # Render it
  gl.drawElements(gl.Tris, mesh.inds.csizeof, gl.uInt, nil)
  # Clean OpenGL state for this frame, without deleting the object data
  mesh.vao.disable()
  mesh.tex.disable()

]##




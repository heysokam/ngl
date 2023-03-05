#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# std dependencies
import std/strutils
# ndk dependencies
import nstd/types as base
import nstd/C
# Module dependencies
from   ./gl       as gl import nil
import ./types
#__________________________________________________


#__________________________________________________
proc chkShader (id :u32) :void=
  var compiled :i32
  gl.getShaderiv(id, gl.CompileStatus, compiled.addr);
  if not compiled.bool:
    var logLength: i32
    var msg = newString(1024)
    gl.getShaderInfoLog(id, 1024, logLength.addr, msg.cstring);
    echo "::ERR Shader didn't compile correctly:"
    echo msg.join
#__________________________________________________
proc chkProgram (id :u32) :void=
  var ok :i32
  gl.getProgramiv(id, gl.LinkStatus, ok.addr);
  if not ok.bool:
    var logLength :i32
    var msg = newString(1024)
    gl.getProgramInfoLog(id, 1024, logLength.addr, msg.cstring)
    echo "::ERR Shader Program wasn't linked correctly:"
    echo msg.join
  gl.validateProgram(id)
  gl.getProgramiv(id, gl.ValidateStatus, ok.addr);
  if not ok.bool:
    var logLength :i32
    var msg = newString(1024)
    gl.getProgramInfoLog(id, 1024, logLength.addr, msg.cstring)
    echo "::ERR Shader Program is invalid:"
    echo msg.join
#__________________________________________________
proc newShaderVert *(file :str) :ShaderVert=
  new result
  # Set the vertex shader
  result.id   = gl.createShader(gl.VertexShader)
  result.file = file
  result.src  = file.readFile
  let tmp     = result.src.cstring
  let length  = result.src.len.i32
  gl.shaderSource(result.id, 1, tmp.caddr, length.caddr)
  gl.compileShader(result.id)
  chkShader(result.id)
#__________________________________________________
proc newShaderFrag *(file :str) :ShaderFrag=
  new result
  # Set the fragment shader
  result.id   = gl.createShader(gl.FragmentShader)
  result.file = file
  result.src  = file.readFile
  let tmp     = result.src.cstring
  let length  = result.src.len.i32
  gl.shaderSource(result.id, 1, tmp.caddr, length.caddr)
  gl.compileShader(result.id)
  chkShader(result.id)
#__________________________________________________
proc newShaderProg *(vert :ShaderVert; frag :ShaderFrag) :ShaderProg=
  new result
  # Join fragment and vertex shader into a shader program
  result.id = gl.createProgram()
  gl.attachShader(result.id, vert.id)
  gl.attachShader(result.id, frag.id)
  gl.linkProgram(result.id)
  chkProgram(result.id)
  # Delete shaders. Linked to the program, and not needed anymore
  gl.deleteShader(vert.id)
  gl.deleteShader(frag.id)
#__________________________________________________
proc newShaderProg *(vertFile, fragFile :str) :ShaderProg=
  var vert = vertFile.newShaderVert
  var frag = fragFile.newShaderFrag
  result = newShaderProg(vert, frag)
#__________________________________________________
proc newShaderProg *() :ShaderProg=  ShaderProg(id:0)
  ## Creates a new object, with all values set to 0 or empty
#__________________________________________________
proc term *(prog :ShaderProg) :void=  gl.deleteProgram(prog.id)
  ## Deletes the target program from OpenGL
#__________________________________________________
proc get *(shd :ShaderProg; uName :str) :cint=
  ## Gets the location number for the given uniform name
  # TODO: Use binding instead of location
  result = gl.getUniformLocation(shd.id, uName)
  # if result == -1: log &"ERR : Couldn't get the location of uniform {uName}\tat shader.id = {shd.id}"
#__________________________________________________


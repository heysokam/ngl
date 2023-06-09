#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# std dependencies
import std/strutils
# ndk dependencies
import nstd/types as base
import nstd/C
# Module dependencies
import ./types/shader
from   ./gl as gl import nil
#__________________________________________________


#__________________________________________________
# Compilation Error check
#_____________________________
proc chk (shader :ShaderVert | ShaderFrag) :void=
  ## Checks if the Shader was compiled correctly
  var compiled :i32
  gl.getShaderiv(shader.id, gl.CompileStatus, compiled.addr);
  if not compiled.bool:
    var logLength: i32
    var msg = newString(1024)
    gl.getShaderInfoLog(shader.id, 1024, logLength.addr, msg.cstring);
    echo "::ERR Shader didn't compile correctly:"
    echo msg.join
#__________________________________________________
proc chk (prog :ShaderProg) :void=
  ## Checks if the ShaderProg is valid and was linked correctly
  var ok :i32
  gl.getProgramiv(prog.id, gl.LinkStatus, ok.addr);
  if not ok.bool:
    var logLength :i32
    var msg = newString(1024)
    gl.getProgramInfoLog(prog.id, 1024, logLength.addr, msg.cstring)
    echo "::ERR Shader Program wasn't linked correctly:"
    echo msg.join
  gl.validateProgram(prog.id)
  gl.getProgramiv(prog.id, gl.ValidateStatus, ok.addr);
  if not ok.bool:
    var logLength :i32
    var msg = newString(1024)
    gl.getProgramInfoLog(prog.id, 1024, logLength.addr, msg.cstring)
    echo "::ERR Shader Program is invalid:"
    echo msg.join

#__________________________________________________
# Vertex Shader
#_____________________________
proc newShaderVertCode *(code :str) :ShaderVert=
  ## Creates and compiles a new ShaderVert from the given source code string.
  new result
  result.id   = gl.createShader(gl.VertexShader)
  result.src  = code
  let tmp     = result.src.cstring
  let length  = result.src.len.i32
  gl.shaderSource(result.id, 1, tmp.caddr, length.caddr)
  gl.compileShader(result.id)
  result.chk()
#_____________________________
proc newShaderVert *(file :str) :ShaderVert=  newShaderVertCode(file.readFile)
  ## Creates and compiles a new ShaderVert from the given source code file.

#__________________________________________________
# Fragment Shader
#_____________________________
proc newShaderFragCode *(code :str) :ShaderFrag=
  ## Creates and compiles a new ShaderFrag from the given source code string.
  new result
  result.id   = gl.createShader(gl.FragmentShader)
  result.src  = code
  let tmp     = result.src.cstring
  let length  = result.src.len.i32
  gl.shaderSource(result.id, 1, tmp.caddr, length.caddr)
  gl.compileShader(result.id)
  result.chk()
#_____________________________
proc newShaderFrag *(file :str) :ShaderFrag=  newShaderFragCode(file.readFile)
  ## Creates and compiles a new ShaderFrag from the given source code file.

#__________________________________________________
# Shader Program
#_____________________________
proc newShaderProg *() :ShaderProg=  ShaderProg(id:0)
  ## Creates a new object, with all values set to 0 or empty
#__________________________________________________
proc newShaderProg *(vert :ShaderVert; frag :ShaderFrag) :ShaderProg=
  ## Creates and compiles a new ShaderProg from the given vert and frag objects.
  new result
  # Join fragment and vertex shader into a shader program
  result.id = gl.createProgram()
  gl.attachShader(result.id, vert.id)
  gl.attachShader(result.id, frag.id)
  gl.linkProgram(result.id)
  result.chk()
  # Delete shaders. Linked to the program, not needed anymore
  gl.deleteShader(vert.id)
  gl.deleteShader(frag.id)
#__________________________________________________
proc newShaderProgCode *(vertCode, fragCode :str) :ShaderProg=
  ## Creates and compiles a new ShaderProg from the given vert+frag source code strings.
  new result
  var vert = vertCode.newShaderVertCode
  var frag = fragCode.newShaderFragCode
  result = newShaderProg(vert, frag)
#__________________________________________________
proc newShaderProg *(vertFile, fragFile :str) :ShaderProg=
  ## Creates and compiles a new ShaderProg from the given vert+frag source code files.
  new result
  var vert = vertFile.newShaderVert
  var frag = fragFile.newShaderFrag
  result   = newShaderProg(vert, frag)
#__________________________________________________
proc get *(shd :ShaderProg; uName :str) :cint=
  ## Gets the location number for the given uniform name
  # TODO: Use binding instead of location
  result = gl.getUniformLocation(shd.id, uName)
  # if result == -1: log &"ERR : Couldn't get the location of uniform {uName}\tat shader.id = {shd.id}"
#__________________________________________________
proc enable  *(prog :ShaderProg) :void=  gl.useProgram(prog.id)     ## Marks the shader program for use in OpenGL.
proc disable *(prog :ShaderProg) :void=  gl.useProgram(0)           ## Clears any currently bound Program.
proc term    *(prog :ShaderProg) :void=  gl.deleteProgram(prog.id)  ## Deletes the target program from OpenGL.


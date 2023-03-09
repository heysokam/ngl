#:___________________________________________________
#  ngl  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:___________________________________________________
# std dependencies
import std/strformat
import std/strutils
# External dependencies
import pkg/chroma
from   pkg/staticglfw as glfw import nil
# ndk dependencies
import nstd/types as base
import nmath
# import ngl
import ngl/types
import ngl/gl as gl
import ngl/C
# Module dependencies
import ./cfg


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
const inds = @[uvec3( 0, 1, 2 )] # CCW Winding order (left,right,top). One triangle, one uvec3 ind
const pos  = @[
  vec3(-0.5, -0.5, 0.0), # left
  vec3( 0.5, -0.5, 0.0), # right
  vec3( 0.0,  0.5, 0.0)  # top
]

#__________________________________________________
# State
var render    :Renderer
var triangle  :RenderMesh

#__________________________________________________
# Run
proc start()=   # render.init(...)
  echo "Initializing: Renderer"
  #_______________________________________
  # Initialize the Renderer object
  #   render = newRenderer(...)
  render     = Renderer(
    win:     Window(ct: nil, size: cfg.res, title: cfg.name),
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
  render.win.title = cfg.name
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

  #_______________________________________
  # Initialize the triangle data
  triangle.vao     = VAO()                 # alloc the VAO ref object
  triangle.vao.pos = MeshAttribute[Vec3](attr: OpenGLAttrib(), vbo: VBO[Vec3](data: pos))  # add positions, and alloc the Attr and VBO ref object
  triangle.inds    = Indices(data: inds)   # add indices,   and alloc the EBO ref object
  # Register the data into OpenGL
  # triangle.register()
  #   mesh.vao.register              # Init VAO
  gl.createVertexArrays(1, triangle.vao.id.addr)
  #   mesh.vao.register(mesh.inds)   # Init EBO
  gl.createBuffers(1, triangle.inds.id.addr)
  gl.namedBufferStorage(
    buffer = triangle.inds.id,
    size   = (triangle.inds.data[0].sizeof * triangle.inds.data.len).cint,
    data   = triangle.inds.data[0].addr,
    flags  = gl.DynamicStorageBit
    )
  gl.vertexArrayElementBuffer(triangle.vao.id, triangle.inds.id)
  #   mesh.vao.register(mesh.vao.pos, Attr.aPos)     # Init aPos attribute
  gl.createBuffers(1, triangle.vao.pos.vbo.id.addr)
  gl.namedBufferStorage(
    buffer = triangle.vao.pos.vbo.id, 
    size   = (triangle.vao.pos.vbo.data[0].sizeof * triangle.vao.pos.vbo.data.len).cint,
    data   = triangle.vao.pos.vbo.data[0].addr, 
    flags  = gl.DynamicStorageBit
    )
  #     triangle.vao.pos.attr = newGLAttrib(...)
  triangle.vao.pos.attr.name   = "aPos"    # Name is not needed with DSA, but for clarity
  triangle.vao.pos.attr.id     = 0         # layout (location = 0) in aPos;  so this is 0
  triangle.vao.pos.attr.typ    = gl.Float  # Alias for cGL_FLOAT
  triangle.vao.pos.attr.size   = 3         # Vec3, so size = 3
  triangle.vao.pos.attr.stride = triangle.vao.pos.attr.size * sizeof(float32).int32
  #     << end newGLAttrib
  gl.vertexArrayVertexBuffer(
    vaobj        = triangle.vao.id,
    bindingindex = triangle.vao.pos.attr.id,
    buffer       = triangle.vao.pos.vbo.id,
    offset       = 0,
    stride       = triangle.vao.pos.attr.stride.cint
    )
  gl.enableVertexArrayAttrib(triangle.vao.id, triangle.vao.pos.attr.id)
  gl.vertexArrayAttribFormat(
    vaobj          = triangle.vao.id,
    attribindex    = triangle.vao.pos.attr.id,
    size           = triangle.vao.pos.attr.size.cint,
    `type`         = triangle.vao.pos.attr.typ,
    normalized     = gl.False,
    relativeoffset = 0
    )
  gl.vertexArrayAttribBinding(
    vaobj        = triangle.vao.id,
    attribindex  = triangle.vao.pos.attr.id,
    bindingindex = triangle.vao.pos.attr.id
    )

  #_______________________________________
  # Initialize the shader program
  #_______________________________________

  #_____________________________
  #   Initialize the VertexShader
  #   newShaderVertCode(vert)
  var vertObj = ShaderVert()
  vertObj.src = vert
  vertObj.id  = gl.createShader(gl.VertexShader)
  var tmpCode = vertObj.src.cstring
  var tmpLength = vertObj.src.len.int32
  gl.shaderSource(
    shader   = vertObj.id, 
    count    = 1, 
    `string` = cast[cstringArray](tmpCode.unsafeAddr), 
    length   = tmpLength.unsafeaddr
    )
  gl.compileShader(vertObj.id)
  #___________________
  #   Error check the VertexShader
  #   vertObj.chk()
  # Checks if the VertexShader was compiled correctly
  var compiled :int32
  gl.getShaderiv(vertObj.id, gl.CompileStatus, compiled.addr);
  if not compiled.bool:
    var logLength: int32
    var msg = newString(1024)
    gl.getShaderInfoLog(vertObj.id, 1024, logLength.addr, msg.cstring);
    echo "::ERR Shader didn't compile correctly:"
    echo msg.join

  #_____________________________
  #   Initialize the FragmentShader
  #   newShaderFragCode(frag)
  var fragObj = ShaderFrag()
  fragObj.src = frag
  fragObj.id  = gl.createShader(gl.FragmentShader)
  tmpCode     = fragObj.src.cstring
  tmpLength   = fragObj.src.len.int32
  gl.shaderSource(
    shader   = fragObj.id, 
    count    = 1, 
    `string` = cast[cstringArray](tmpCode.unsafeAddr), 
    length   = tmpLength.unsafeaddr
    )
  gl.compileShader(fragObj.id)
  #___________________
  #   Error check the FragmentShader
  #   fragObj.chk()
  compiled = 0  # Reset compile status variable
  gl.getShaderiv(fragObj.id, gl.CompileStatus, compiled.addr);
  if not compiled.bool:
    var logLength: int32
    var msg = newString(1024)
    gl.getShaderInfoLog(fragObj.id, 1024, logLength.addr, msg.cstring);
    echo "::ERR Shader didn't compile correctly:"
    echo msg.join

  #_____________________________
  #   Initialize the ShaderProgram
  #   newShaderProg(vertObj, fragObj)
  triangle.shd = ShaderProg()
  # Join fragment and vertex shader into a shader program
  triangle.shd.id = gl.createProgram()
  gl.attachShader(triangle.shd.id, vertObj.id)
  gl.attachShader(triangle.shd.id, fragObj.id)
  gl.linkProgram(triangle.shd.id)
  #___________________
  #   Error check the ShaderProgram
  #   triangle.shd.chk()
  var ok :int32
  gl.getProgramiv(triangle.shd.id, gl.LinkStatus, ok.addr);
  if not ok.bool:
    var logLength :int32
    var msg = newString(1024)
    gl.getProgramInfoLog(triangle.shd.id, 1024, logLength.addr, msg.cstring)
    echo "::ERR Shader Program wasn't linked correctly:"
    echo msg.join
  gl.validateProgram(triangle.shd.id)
  gl.getProgramiv(triangle.shd.id, gl.ValidateStatus, ok.addr);
  if not ok.bool:
    var logLength :int32
    var msg = newString(1024)
    gl.getProgramInfoLog(triangle.shd.id, 1024, logLength.addr, msg.cstring)
    echo "::ERR Shader Program is invalid:"
    echo msg.join

  #_____________________________
  # Delete shaders. Linked to the program, and not needed anymore
  gl.deleteShader(vertObj.id)
  gl.deleteShader(fragObj.id)


proc loop()=
  #_____________________________
  # Clear the screen
  gl.clear()
  #_____________________________
  # Draw the triangle to the screen
  #   mesh.vao.enable()   # Define what will be rendered (VAO)
  gl.bindVertexArray(triangle.vao.id)
  #   mesh.shd.enable()   # Enable the shader program of the mesh
  gl.useProgram(triangle.shd.id)
  #   mesh.inds.draw()    # Render it
  gl.drawElements(
    mode    = gl.Tris,
    count   = (triangle.inds.data[0].sizeof * triangle.inds.data.len).cint,
    `type`  = gl.uInt,
    indices = nil
    )
  #   mesh.vao.disable()  # Clean OpenGL state for this frame, without deleting the object data
  gl.bindVertexArray(0)  # Binding to 0 is the same as unbinding
  #_____________________________
  # Update the window screen
  glfw.swapBuffers(render.win.ct)

proc exit() :bool= glfw.windowShouldClose(render.win.ct).bool
proc stop()=
  glfw.destroyWindow(render.win.ct)
  glfw.terminate()

#__________________________________________________
when isMainModule:
  start()
  while not exit(): loop()
  stop()


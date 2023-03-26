#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# Library dependencies
import ../../types/core
import ../../types/tech
import ../../types/body
from   ../../gl import nil
import ../../C
import ../../shader


const vert = """
#version 460 core
layout (location = 0) in vec3 aPos;
void main() { gl_Position = vec4(aPos, 1.0); }
"""
const frag = """
#version 460 core
out vec4 fColor;
void main() { fColor = vec4(1.0, 0.5, 0.0, 1.0); }
"""

#_____________________________
# Constructor
#___________________
proc newSimplePass *() :RenderPass=
  let shd = newShaderProgCode(vert, frag)
  RenderPass(name: Pass.Simple, shd: shd)


#_____________________________
# Enable
#___________________
proc enable *(pass :RenderPass) :void=
  ## Enables the shaders of the Simple pass.
  pass.shd.enable()


#_____________________________
# Apply/Draw
#____________________
proc apply *(r: Renderer; pass :RenderPass; mesh :RenderMesh) :void=
  ## Draws the currently bound VAO, using the EBO of the mesh.
  gl.drawElements(gl.Tris, mesh.inds.csizeof, gl.uInt, nil)


#_____________________________
# Disable
#____________________
proc disable *(pass :RenderPass) :void=
  ## Disables the shaders of the Simple pass.
  pass.shd.disable()


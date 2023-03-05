#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# External dependencies
import pkg/pixie
# ndk dependencies
import nstd/types as base
import nstd/C
# Module dependencies
import ./types
import ./C  as Cgl
from   ./gl as gl     import nil
from   ./gl as glType import Enum


#____________________
proc newTexture *() :Texture= 
  ## Generates an empty GLTexture2D image (1x1)
  new result
  result.id   = result.id.type.high  # Init to something obviously wrong. Will be overwritten by DSA registering.
  result.typ  = gl.Tex2D
  result.file = "UninitializedTexture"
  result.img  = newImage(1,1)  # Pixie does not allow 0x0
#____________________
proc newTexture *(file :str) :Texture= 
  ## Generates a GLTexture2D image
  ## Assumes a pixie supported file format is given as input
  new result
  # Store input data
  result.id   = u32.high  # Init to something obviously wrong. Will be overwritten by DSA registering.
  result.typ  = gl.Tex2D
  result.file = file
  # Load image
  # Assume supported format, and decode it
  result.img  = file.readImage
  result.img.flipVertical   # Flip for OpenGL texture coordinates marking 0,0 at bottom left


#____________________
proc enable  *(tex :Texture; uid :u32) :void= 
  ## Binds and activates the target texture.id to OpenGL's texture unit `uid`
  ## DSA does not need GLTexture0+number, it only requires a unit id instead
  gl.bindTextureUnit(uid, tex.id)
#____________________
template disable *(tex :Texture) :void=  gl.bindTexture(tex.typ, 0)  # Bind to 0 == unbind
  ## Unbinds any texture, of the input type, currently bound to OpenGL
  ## Does nothing if a texture of this type is not currently bound

#____________________
proc register *(tex :Texture) :void= 
  ## Registers the given texture in OpenGL:
  ## - Create the texture object with tex.id  (no need to bind with DSA)
  ## - Sets default wrapping, filtering and mipmaps
  gl.createTextures(tex.typ, 1, tex.id.addr)  # Create the texture object (no need to bind with DSA)
  # TODO: Set these properties based on the texture object data
  # Wrapping
  gl.textureParameteri(tex.id, gl.WrapS, gl.Repeat)  # default: GLRepeat
  gl.textureParameteri(tex.id, gl.WrapT, gl.Repeat)
  # Filtering: Minification and Magnification styles
  # TODO: Add choice between nearest and linear
  gl.textureParameteri(tex.id, gl.FilterMin, gl.LinearMipmapLinear)
  gl.textureParameteri(tex.id, gl.FilterMag, gl.Linear)
  # Load the texture data into the OpenGL texture object
  let levels :gl.Size= 1  # Mipmap levels count
  gl.textureStorage2D(tex.id, levels, gl.Rgba8, tex.img.width.i32, tex.img.height.i32)
  gl.textureSubImage2D(tex.id, 0, 0, 0, tex.img.width.i32, tex.img.height.i32, gl.Rgba, gl.uByte, tex.img.caddr)
  # Generate its mipmap levels
  gl.generateTextureMipmap(tex.id)


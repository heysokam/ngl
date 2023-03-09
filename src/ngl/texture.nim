#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# std dependencies
import std/os
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
proc newTexture *(
    file         :str=         ""; 
    internalName :str=         ""; 
    filterMin    :FilterType=  Nearest;
    filterMag    :FilterType=  Nearest;
    wrapS        :WrapType=    Repeat;
    wrapT        :WrapType=    Repeat;
    mips         :i32=         1;
    ) :Texture= 
  ## Generates a GLTexture2D image.
  ## Assumes a pixie supported file format is stored in the given `file` input path.
  ## When omitting a parameter, defaults will be:
  ##   - file            : an empty GLTexture2D image (1x1) will be created.
  ##   - internalName    : Will use the file's filename without extension.
  ##   - filter[Min/Mag] : Will use Nearest filtering.
  ##   - wrap[S/T]       : Will use Repeat for texture wrapping.
  ##   - mips            : Will set mipmap levels to 1, and they won't be generated when uploading.
  new result
  # Store input data
  result.id         = u32.high  # Init to something obviously wrong. Will be overwritten by DSA registering.
  result.typ        = gl.Tex2D
  result.filter.min = filterMin
  result.filter.mag = filterMag
  result.wrap.S     = wrapS
  result.wrap.T     = wrapT
  result.mips       = mips
  # Load image
  if file == "":  # Path was not given, so create an empty texture
    result.file = NotInitialized
    result.name = internalName
    result.img  = newImage(1,1)  # Pixie does not allow 0x0
    return
  # Assume supported format, and decode it
  result.file = file
  result.name = if internalName != "": internalName else: file.splitFile().name
  result.img  = file.readImage
  result.img.flipVertical   # Flip for OpenGL texture coordinates marking 0,0 at bottom left

#____________________
template valid *(tex :Texture) :bool=
  ## Checks if the given texture contains valid data.
  tex.name != "" and tex.file != NotInitialized
#____________________
template registered *(tex :Texture) :bool=  tex.id != u32.high
  ## Checks if the given texture has already been registered to OpenGL.

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
  ## - Creates the GLtexture object with tex.id, without binding it (DSA)
  ## - Sets wrapping, filtering and mipmaps as stored in the Texture object
  ## - Generates mipmaps only when `tex.mips` levels is > 1
  gl.createTextures(tex.typ, 1, tex.id.addr)  # Create the texture object (DSA)
  # Wrapping
  gl.textureParameteri(tex.id, gl.WrapS, gl.i32(tex.wrap.S))
  gl.textureParameteri(tex.id, gl.WrapT, gl.i32(tex.wrap.T))
  # Filtering: Minification and Magnification
  gl.textureParameteri(tex.id, gl.FilterMin, gl.i32(tex.filter.min))
  gl.textureParameteri(tex.id, gl.FilterMag, gl.i32(tex.filter.mag))
  # Load the texture data into the OpenGL texture object
  # TODO: Set Format variables depending on the input texture data
  gl.textureStorage2D(tex.id, tex.mips, gl.Rgba8, tex.img.width.i32, tex.img.height.i32)
  gl.textureSubImage2D(tex.id, 0, 0, 0, tex.img.width.i32, tex.img.height.i32, gl.Rgba, gl.uByte, tex.img.caddr)
  # Generate its mipmap levels
  if tex.mips > 1: gl.generateTextureMipmap(tex.id)


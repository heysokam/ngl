#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# External dependencies
import pkg/chroma
import pkg/opengl

#____________________
# DSA
const bindTextureUnit           * = glBindTextureUnit
const createTextures            * = glCreateTextures
const textureParameteri         * = glTextureParameteri
const generateTextureMipmap     * = glGenerateTextureMipmap
const textureSubImage2D         * = glTextureSubImage2D
const textureStorage2D          * = glTextureStorage2D

#____________________
# TODO: Organize -> global and non-dsa
## Textures
const genTextures               * = glGenTextures
const bindTexture               * = glBindTexture
proc texImage2D *(target :GLenum; level :SomeInteger; internalformat :GLenum; width, height, border :SomeInteger; format, typ :GLenum; pixels :seq[ColorRGBX]) :void=
  glTexImage2D(target, GLint level, GLint internalFormat, GLsizei width, GLsizei height, border.GLint, format, typ, cast[pointer](pixels[0].unsafeAddr))
proc texImage2D *(target :GLenum; level :SomeInteger; internalformat :GLenum; width, height, border :SomeInteger; format, typ :GLenum; pixels :seq[ColorRGBA]) :void=
  glTexImage2D(target, GLint level, GLint internalFormat, GLsizei width, GLsizei height, border.GLint, format, typ, cast[pointer](pixels[0].unsafeAddr))
var   activeTexture             * = glActiveTexture
const Diffuse                   * = GL_TEXTURE0
### Tex: Parameters
var   texParameteri             * = glTexParameteri
const Tex2D                     * = GL_TEXTURE_2D
const FilterMag                 * = GL_TEXTURE_MAG_FILTER
const FilterMin                 * = GL_TEXTURE_MIN_FILTER
const Nearest                   * = GL_NEAREST
const WrapS                     * = GL_TEXTURE_WRAP_S
const WrapT                     * = GL_TEXTURE_WRAP_T
const Clamp                     * = GL_CLAMP
const Repeat                    * = GL_REPEAT
const LinearMipmapLinear        * = GL_LINEAR_MIPMAP_LINEAR
const Linear                    * = GL_LINEAR
### Tex: Formats
const Rgba                      * = GL_RGBA
const Rgba8                     * = GL_RGBA8
const uByte                     * = GL_UNSIGNED_BYTE
const uInt                      * = GL_UNSIGNED_INT


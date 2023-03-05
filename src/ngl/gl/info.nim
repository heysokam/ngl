#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# External dependencies
import pkg/opengl


#____________________
# Info and Errors
const CompileStatus                   * = GL_COMPILE_STATUS
const InfoLogLength                   * = GL_INFO_LOG_LENGTH
const LinkStatus                      * = GL_LINK_STATUS
const ValidateStatus                  * = GL_VALIDATE_STATUS
const getIntegerv                     * = glGetIntegerv
const getBooleanv                     * = glGetBooleanv

#____________________
# System Limits
const Max_Cubemap_TextureSize         * = GL_MAX_CUBE_MAP_TEXTURE_SIZE
const Max_DrawBuffers                 * = GL_MAX_DRAW_BUFFERS
const Max_Fragment_UniformComponents  * = GL_MAX_FRAGMENT_UNIFORM_COMPONENTS
const Max_Texture_Size                * = GL_MAX_TEXTURE_SIZE
const Max_Texture_ImageUnits          * = GL_MAX_TEXTURE_IMAGE_UNITS
const Max_CombinedTextureImageUnits   * = GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS
const Max_VaryingFloats               * = GL_MAX_VARYING_FLOATS
const Max_Vertex_Attribs              * = GL_MAX_VERTEX_ATTRIBS
const Max_Vertex_TextureImageUnits    * = GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS
const Max_Vertex_UniformComponents    * = GL_MAX_VERTEX_UNIFORM_COMPONENTS
const Max_ViewportDims                * = GL_MAX_VIEWPORT_DIMS
const Stereo                          * = GL_STEREO


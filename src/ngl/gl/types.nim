#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# External dependencies
import pkg/opengl

#____________________
# OpenGL: Types remap
type  u32   * = GLuint
type  Size  * = GLsizei
type  i32   * = GLint
type  Bool  * = GLboolean
type  Enum  * = GLenum
const False * = GL_FALSE
const True  * = GL_TRUE
var   Float * = cGL_FLOAT


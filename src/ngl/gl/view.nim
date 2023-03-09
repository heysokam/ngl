#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# External dependencies
import pkg/opengl

#____________________
# Drawing mode
const polygonMode   * = glPolygonMode
const FrontAndBack  * = GL_FRONT_AND_BACK
const Line          * = GL_LINE
const Fill          * = GL_FILL

#____________________
# Window
var   viewport       * = glViewport


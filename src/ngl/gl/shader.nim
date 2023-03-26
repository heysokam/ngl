#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# External dependencies
import pkg/opengl

#____________________
## Vertex & Fragment
const VertexShader              * = GL_VERTEX_SHADER
const FragmentShader            * = GL_FRAGMENT_SHADER
const getShaderiv               * = glGetShaderiv
const getShaderInfoLog          * = glGetShaderInfoLog
const shaderSource              * = glShaderSource
const compileShader             * = glCompileShader
var   createShader              * = glCreateShader
const deleteShader              * = glDeleteShader

#____________________
## Program
const attachShader              * = glAttachShader
const getProgramInfoLog         * = glGetProgramInfoLog
const getProgramiv              * = glGetProgramiv
const validateProgram           * = glValidateProgram
var   useProgram                * = glUseProgram
const linkProgram               * = glLinkProgram
var   createProgram             * = glCreateProgram
const deleteProgram             * = glDeleteProgram


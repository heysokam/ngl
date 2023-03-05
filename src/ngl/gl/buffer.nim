#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# External dependencies
import pkg/opengl

#____________________
# DSA: General
const createBuffers             * = glCreateBuffers
const namedBufferStorage        * = glNamedBufferStorage
const DynamicStorageBit         * = GL_DYNAMIC_STORAGE_BIT
const unmapNamedBuffer          * = glUnmapNamedBuffer
const deleteBuffers             * = glDeleteBuffers
#____________________
# DSA: VAO
const createVertexArrays        * = glCreateVertexArrays
const deleteVertexArrays        * = glDeleteVertexArrays
#____________________
# DSA: VBO
const vertexArrayVertexBuffer   * = glVertexArrayVertexBuffer
#____________________
# DSA: EBO
const vertexArrayElementBuffer  * = glVertexArrayElementBuffer
const drawElements              * = glDrawElements
#____________________
# DSA: Attributes
const enableVertexArrayAttrib   * = glEnableVertexArrayAttrib
const vertexArrayAttribFormat   * = glVertexArrayAttribFormat
const vertexArrayAttribBinding  * = glVertexArrayAttribBinding

#____________________
# TODO: Organize -> global and non-dsa
#____________________
# VAO
const genVertexArrays           * = glGenVertexArrays
var   bindVertexArray           * = glBindVertexArray
var   drawArrays                * = glDrawArrays
const Tris                      * = GL_TRIANGLES
# VBO
const genBuffers                * = glGenBuffers
const bindBuffer                * = glBindBuffer
const bufferData                * = glBufferData
const ArrayBuffer               * = GL_ARRAY_BUFFER
const ElementArrayBuffer        * = GL_ELEMENT_ARRAY_BUFFER
const StaticDraw                * = GL_STATIC_DRAW
# Attributes
const vertexAttribPointer       * = glVertexAttribPointer
var   enableVertexAttribArray   * = glEnableVertexAttribArray
const disableVertexAttribArray  * = glDisableVertexAttribArray


#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# External dependencies
import pkg/opengl

# Non-DSA
# Uniforms
const getUniformLocation * = glGetUniformLocation
proc uniform1i  *(loc, v0 :SomeInteger) :void=  glUniform1i(GLint loc, GLint v0)
proc uniform1f  *(loc :SomeInteger; v0 :SomeFloat) :void=  glUniform1f(GLint loc, GLfloat v0)
proc uniform1iv *(loc, count :SomeInteger; valptr :ptr GLint)   :void=  glUniform1iv(GLint loc, GLsizei count, valptr)
proc uniform1fv *(loc, count :SomeInteger; valptr :ptr GLfloat) :void=  glUniform1fv(GLint loc, GLsizei count, valptr)
proc uniform2fv *(loc, count :SomeInteger; valptr :ptr GLfloat) :void=  glUniform2fv(GLint loc, GLsizei count, valptr)
proc uniform3fv *(loc, count :SomeInteger; valptr :ptr GLfloat) :void=  glUniform3fv(GLint loc, GLsizei count, valptr)
proc uniform4fv *(loc, count :SomeInteger; valptr :ptr GLfloat) :void=  glUniform4fv(GLint loc, GLsizei count, valptr)
proc uniformMatrix4fv *(loc, count :SomeInteger; transpose :bool; valptr :ptr GLfloat) :void=
  glUniformMatrix4fv(GLint loc, GLsizei count, GLboolean transpose, valptr)


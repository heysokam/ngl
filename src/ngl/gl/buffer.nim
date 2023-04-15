#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# External dependencies
import pkg/opengl

#______________________________
# Contains only DSA functions |
#______________________________

#____________________
# General
const DynamicStorageBit           * = GL_DYNAMIC_STORAGE_BIT
const StaticDraw                  * = GL_STATIC_DRAW
#____________________
# VAO
const createVertexArrays          * = glCreateVertexArrays
const deleteVertexArrays          * = glDeleteVertexArrays
var   bindVertexArray             * = glBindVertexArray
const Tris                        * = GL_TRIANGLES
#____________________
# xBO
const bindBuffer                  * = glBindBuffer           ## Bind a named buffer object.
const createBuffers               * = glCreateBuffers        ## Create named Buffer Objects, by specifying the number of buffer objects to create and an array of names.
const deleteBuffers               * = glDeleteBuffers        ## Delete named buffer objects, by specifying the number of buffer objects to delete and an array of names.
const namedBufferStorage          * = glNamedBufferStorage   ## Creates and initializes a buffer object's immutable data store. Only the data properties are immutable, not the data itself.
const namedBufferSubdata          * = glNamedBufferSubData   ## Updates a subset of a buffer object's data store
const mapNamedBuffer              * = glMapNamedBuffer       ## Map all of a buffer object's data store into the client's address space
const mapNamedBufferRange         * = glMapNamedBufferRange  ## Map all or part of a buffer object's data store into the client's address space
const unmapNamedBuffer            * = glUnmapNamedBuffer     ## Release the mapping of a buffer object's data stored in the client's address space
const Read                        * = GL_READ_ONLY
const Write                       * = GL_WRITE_ONLY
const ReadWrite                   * = GL_READ_WRITE
#____________________
# VBO
const Array                       * = GL_ARRAY_BUFFER
const vertexArrayVertexBuffer     * = glVertexArrayVertexBuffer
#____________________
# EBO
const ElementArray                * = GL_ELEMENT_ARRAY_BUFFER
const vertexArrayElementBuffer    * = glVertexArrayElementBuffer
const drawElements                * = glDrawElements
#____________________
# Attributes
const enableVertexArrayAttrib     * = glEnableVertexArrayAttrib
const vertexArrayAttribFormat     * = glVertexArrayAttribFormat
const vertexArrayAttribBinding    * = glVertexArrayAttribBinding
const disableVertexArrayAttrib    * = glDisableVertexArrayAttrib
#____________________
# UBO
const Uniform                     * = GL_UNIFORM_BUFFER
const uniformBlockBinding         * = glUniformBlockBinding  ## Assign a binding point to an active uniform block
const bindBufferRange             * = glBindBufferRange      ## Bind a range within a buffer object to an indexed buffer target

#____________________
# SSBO
const ShaderStorage               * = GL_SHADER_STORAGE_BUFFER

#____________________
# FBO
var   bindFramebuffer             * = glBindFramebuffer              ## Binds the framebuffer object to the specified target. Target must be either gl.Framebuffer, gl.FramebufferDraw or gl.FramebufferRead.
const createFramebuffers          * = glCreateFramebuffers
const namedFramebufferTexture     * = glNamedFramebufferTexture      ## Attach a level of a texture object as a logical buffer of a framebuffer object
const namedFramebufferDrawBuffer  * = glNamedFramebufferDrawBuffer   ## Specify a color buffer for the Framebuffer. All others will be set to GL_NONE
const namedFramebufferDrawBuffers * = glNamedFramebufferDrawBuffers  ## Specify multiple color buffers for the Framebuffer. ALl others will be set to GL_NONE
const checkNamedFramebufferStatus * = glCheckNamedFramebufferStatus  ## Checks the given framebuffer for completeness. Returns gl.Complete on success, or an error code otherwise.
# FBO: Read/Write
const namedFramebufferReadBuffer  * = glNamedFramebufferReadBuffer
proc blitNamedFramebuffer *(read, draw, srcX0, srcY0, srcX1, srcY1, dstX0, dstY0, dstX1, dstY1 :SomeUnsignedInt; mask :GLbitfield; filter :GLint) :void=
  glBlitNamedFramebuffer(GLuint read, GLuint draw,
    GLint srcX0, GLint srcY0, GLint srcX1, GLint srcY1, 
    GLint dstX0, GLint dstY0, GLint dstX1, GLint dstY1, 
    mask, GLenum filter  )
# FBO: Explicit clear
const clearNamedFramebufferfv     * = glClearNamedFramebufferfv   ## For clearing the Color and Depth attachments
const clearNamedFramebufferiv     * = glClearNamedFramebufferiv   ## For clearing the Stencil attachment
const clearNamedFramebufferuiv    * = glClearNamedFramebufferuiv  ## For Color attachments that use uint instead of float
const clearNamedFramebufferfi     * = glClearNamedFramebufferfi   ## For clearing the Depth and Stencil buffers simultaneously.
# FBO: Identifiers
const Framebuffer                 * = GL_FRAMEBUFFER
const FramebufferDraw             * = GL_DRAW_FRAMEBUFFER
const FramebufferRead             * = GL_READ_FRAMEBUFFER
const Color                       * = GL_COLOR
const ColorBit                    * = GL_COLOR_BUFFER_BIT
const Color0                      * = GL_COLOR_ATTACHMENT0
const Depth                       * = GL_DEPTH
const DepthBit                    * = GL_DEPTH_BUFFER_BIT
const DepthAttachment             * = GL_DEPTH_ATTACHMENT
const DepthComponent24            * = GL_DEPTH_COMPONENT24   ## internalformat
const DepthComponent32f           * = GL_DEPTH_COMPONENT32F  ## internalformat
const Stencil                     * = GL_STENCIL
const StencilAttachment           * = GL_STENCIL_ATTACHMENT
const DepthStencil                * = GL_DEPTH_STENCIL
# FBO: Validation
const Complete                    * = GL_FRAMEBUFFER_COMPLETE
const Undefined                   * = GL_FRAMEBUFFER_UNDEFINED
const IncompleteAttachment        * = GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT
const IncompleteMissingAttachment * = GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT
const IncompleteDrawBuffer        * = GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER
const IncompleteReadBuffer        * = GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER
const Unsupported                 * = GL_FRAMEBUFFER_UNSUPPORTED
const IncompleteMultisample       * = GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE
const IncompleteLayerTargets      * = GL_FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS


proc getErr *(code :GLEnum) :string=
  ## Returns a string containing the reason for the given FBO Incompleteness code.
  case code
  of GLEnum(0):                   result = """
    An error occurred while checking for completeness of a framebuffer"""
  of Undefined:                   result = """
    The specified framebuffer is the default read or draw framebuffer, 
    but the default framebuffer does not exist."""
  of IncompleteAttachment:        result = """
    One or more of the framebuffer attachment points are framebuffer incomplete."""
  of IncompleteMissingAttachment: result = """
    The framebuffer does not have at least one image attached to it."""
  of IncompleteDrawBuffer:        result = """
    The value of GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE is GL_NONE 
    for any color attachment point(s) named by GL_DRAW_BUFFERi."""
  of IncompleteReadBuffer:        result = """
    GL_READ_BUFFER is not GL_NONE and the value of GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE is GL_NONE
    for the color attachment point named by GL_READ_BUFFER."""
  of Unsupported:                 result = """
    The combination of internal formats of the attached images
    violates an implementation-dependent set of restrictions."""
  of IncompleteMultisample:       result = """
    One or multiple of this list of errors was raised for a framebuffer:
    1: The value of GL_RENDERBUFFER_SAMPLES is not the same for all attached renderbuffers;
    2: The value of GL_TEXTURE_SAMPLES is the not same for all attached textures; 
    3: The attached images are a mix of renderbuffers and textures, 
    4: The value of GL_RENDERBUFFER_SAMPLES does not match the value of GL_TEXTURE_SAMPLES. 
    5: The value of GL_TEXTURE_FIXED_SAMPLE_LOCATIONS is not the same for all attached textures; 
    6: The attached images are a mix of renderbuffers and textures, 
    7: The value of GL_TEXTURE_FIXED_SAMPLE_LOCATIONS is not GL_TRUE for all attached textures."""
  of IncompleteLayerTargets:      result = """
    One or more framebuffer attachment is layered, and one or more of the populated framebuffer attachments are not layered, 
    or all populated color attachments are not from textures of the same target."""
  else: result = "Error code not mapped"


##[
## # Framebuffer object functions 
# proc glCreateFramebuffers(n: GLsizei; framebuffers: ptr GLuint)
# proc glNamedFramebufferTexture(framebuffer: GLuint; attachment: GLenum; texture: GLuint; level: GLint)
proc glNamedFramebufferTextureLayer(framebuffer: GLuint; attachment: GLenum; texture: GLuint; level: GLint; layer: GLint)
proc glNamedFramebufferRenderbuffer(framebuffer: GLuint; attachment: GLenum; renderbuffertarget: GLenum; renderbuffer: GLuint)
proc glNamedFramebufferParameteri(framebuffer: GLuint; pname: GLenum; param: GLint)
# proc glNamedFramebufferDrawBuffer(framebuffer: GLuint; mode: GLenum)
# proc glNamedFramebufferDrawBuffers(framebuffer: GLuint; n: GLsizei; bufs: ptr GLenum)
# proc glNamedFramebufferReadBuffer(framebuffer: GLuint; mode: GLenum)
# FBO: Explicit clear
# proc glClearNamedFramebufferiv(framebuffer: GLuint; buffer: GLenum; drawbuffer: GLint; value: ptr GLint)
# proc glClearNamedFramebufferuiv(framebuffer: GLuint; buffer: GLenum; drawbuffer: GLint; value: ptr GLuint)
# proc glClearNamedFramebufferfv(framebuffer: GLuint; buffer: GLenum; drawbuffer: GLint; value: ptr cfloat)
# proc glClearNamedFramebufferfi(framebuffer: GLuint; buffer: GLenum; drawbuffer: GLint; depth: cfloat; stencil: GLint)

# proc glBlitNamedFramebuffer(readFramebuffer: GLuint; drawFramebuffer: GLuint; srcX0: GLint; srcY0: GLint; srcX1: GLint; srcY1: GLint; dstX0: GLint; dstY0: GLint; dstX1: GLint; dstY1: GLint; mask: GLbitfield; filter: GLenum)
  ## Copies a block of pixels from one DSA framebuffer object to another

# FBO: DSA info
# proc glCheckNamedFramebufferStatus(framebuffer: GLuint; target: GLenum): GLenum
  ## Return the completeness status of a DSA framebuffer object when treated as a read or draw framebuffer, depending on the value of target.
proc glGetNamedFramebufferParameteriv(framebuffer: GLuint; pname: GLenum; param: ptr GLint)
  ## Query parameters of a specified DSA framebuffer object.
proc glGetNamedFramebufferAttachmentParameteriv(framebuffer: GLuint; attachment: GLenum; pname: GLenum; params: ptr GLint)
  ## Returns parameters of attachments of a specified DSA framebuffer object.

# FBO: DSA Invalidate Data:
# Can be used for some optimizations on tiler hardware (mobile)
proc glInvalidateNamedFramebufferData(framebuffer: GLuint; numAttachments: GLsizei; attachments: ptr GLenum)
proc glInvalidateNamedFramebufferSubData(framebuffer: GLuint; numAttachments: GLsizei; attachments: ptr GLenum; x: GLint; y: GLint; width: GLsizei; height: GLsizei)



# FBO: Non-DSA
proc glDeleteFramebuffers(n: GLsizei, framebuffers: ptr GLuint)
proc glCheckFramebufferStatus(target: GLenum): GLenum
proc glInvalidateFramebuffer(target: GLenum, numAttachments: GLsizei, attachments: ptr GLenum)
proc glFramebufferRenderbuffer(target: GLenum, attachment: GLenum, renderbuffertarget: GLenum, renderbuffer: GLuint)
proc glFramebufferTexture1D(target: GLenum, attachment: GLenum, textarget: GLenum, texture: GLuint, level: GLint)
proc glFramebufferTexture2D(target: GLenum, attachment: GLenum, textarget: GLenum, texture: GLuint, level: GLint)
proc glGetFramebufferAttachmentParameteriv(target: GLenum, attachment: GLenum, pname: GLenum, params: ptr GLint)
proc glGenFramebuffers(n: GLsizei, framebuffers: ptr GLuint)
proc glFramebufferTextureLayer(target: GLenum, attachment: GLenum, texture: GLuint, level: GLint, layer: GLint)
proc glBlitFramebuffer(srcX0: GLint, srcY0: GLint, srcX1: GLint, srcY1: GLint, dstX0: GLint, dstY0: GLint, dstX1: GLint, dstY1: GLint, mask: GLbitfield, filter: GLenum)
# proc glBindFramebuffer(target: GLenum, framebuffer: GLuint)
proc glGetFramebufferParameteriv(target: GLenum, pname: GLenum, params: ptr GLint)
proc glInvalidateSubFramebuffer(target: GLenum, numAttachments: GLsizei, attachments: ptr GLenum, x: GLint, y: GLint, width: GLsizei, height: GLsizei)
proc glFramebufferTexture(target: GLenum, attachment: GLenum, texture: GLuint, level: GLint)
proc glFramebufferParameteri(target: GLenum, pname: GLenum, param: GLint)
proc glFramebufferTexture3D(target: GLenum, attachment: GLenum, textarget: GLenum, texture: GLuint, level: GLint, zoffset: GLint)
proc glIsFramebuffer(framebuffer: GLuint): GLboolean

## RBO: Renderbuffer object functions 
proc glCreateRenderbuffers(n: GLsizei; renderbuffers: ptr GLuint)
proc glNamedRenderbufferStorage(renderbuffer: GLuint; internalformat: GLenum; width: GLsizei; height: GLsizei)
proc glNamedRenderbufferStorageMultisample(renderbuffer: GLuint; samples: GLsizei; internalformat: GLenum; width: GLsizei; height: GLsizei)
proc glGetNamedRenderbufferParameteriv(renderbuffer: GLuint; pname: GLenum; params: ptr GLint)
]##

##[
# Buffer object functions 
proc glCopyNamedBufferSubData(readBuffer: GLuint; writeBuffer: GLuint; readOffset: GLintptr; writeOffset: GLintptr; size: GLsizeiptr)
proc glClearNamedBufferData(buffer: GLuint; internalformat: GLenum; format: GLenum; `type`: GLenum; data: pointer)
proc glClearNamedBufferSubData(buffer: GLuint; internalformat: GLenum; offset: GLintptr; size: GLsizeiptr; format: GLenum; `type`: GLenum; data: pointer)
proc glFlushMappedNamedBufferRange(buffer: GLuint; offset: GLintptr; length: GLsizeiptr)
proc glGetNamedBufferParameteriv(buffer: GLuint; pname: GLenum; params: ptr GLint)
proc glGetNamedBufferParameteri64v(buffer: GLuint; pname: GLenum; params: ptr GLint64)
proc glGetNamedBufferPointerv(buffer: GLuint; pname: GLenum; params: ptr pointer)
proc glGetNamedBufferSubData(buffer: GLuint; offset: GLintptr; size: GLsizeiptr; data: pointer)
]##

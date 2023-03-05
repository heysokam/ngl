#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# std dependencies
import std/strformat
# External dependencies
import pkg/opengl
# Module dependencies
import ./logger
import ./tools

#____________________
proc debug *(src :GLenum; typ :GLenum; id :GLuint; sev :GLenum; length :GLsizei; msg :ptr GLchar; param :pointer) :void {.stdcall.}=
  ## Debug callback for OpenGL : glDebugMessageCallback
  ## https://www.khronos.org/opengl/wiki/Debug_Output
  if not (sev.int >= GLDebugSeverityLow.int): return
  var  source :string; case src
  of   GLDebugSourceApi:               source = "API"
  of   GLDebugSourceWindowSystem:      source = "Window System"
  of   GLDebugSourceShaderCompiler:    source = "Shader Compiler"
  of   GLDebugSourceThirdParty:        source = "Third Party"
  of   GLDebugSourceApplication:       source = "Application"
  of   GLDebugSourceOther:             source = "Other"
  else: discard
  var  typText :string; case typ
  of   GLDebugTypeError:               typText = "Error"
  of   GLDebugTypeDeprecatedBehavior:  typText = "Deprecated Behavior"
  of   GLDebugTypeUndefinedBehavior:   typText = "Undefined Behavior"
  of   GLDebugTypePortability:         typText = "Portability"
  of   GLDebugTypePerformance:         typText = "Performance"
  of   GLDebugTypeMarker:              typText = "Marker"
  of   GLDebugTypeOther:               typText = "Other"
  else: discard
  var  severity :string; case sev
  of   GLDebugSeverityNotification:    severity = "Notification"  # Anything that isn't an error or performance issue.
  of   GLDebugSeverityLow:             severity = "Low"           # Redundant state change performance warning, or unimportant undefined behavior
  of   GLDebugSeverityMedium:          severity = "Medium"        # Major performance warnings, shader compilation/linking warnings, or the use of deprecated functionality
  of   GLDebugSeverityHigh:            severity = "High"          # All OpenGL Errors, shader compilation/linking errors, or highly-dangerous undefined behavior
  else: discard
  # Log the message, using the callback defined with setLogger() from ngl/logger
  logger.log &"OpenGL Debug {source}, {severity}, {typText}, {id.uint64}:\n:  {msg.toString(length)}"

#____________________
proc setDebug *() :void=
  ## Set OpenGL debug mode. Does nothing in release mode (aka -d:danger)
  ## Assigns the given proc as the logger function.
  ## Said function will be called from the internal state of this lib, when OpenGL sends a debug callback.
  when not defined(danger):
    glEnable(GLDebugOutput)
    glEnable(GLDebugOutputSynchronous)
    glDebugMessageCallback(debug, nil)


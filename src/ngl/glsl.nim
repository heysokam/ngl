# std dependencies
import std/os
import std/strutils
# External dependencies
import pkg/shady
import pkg/vmath
# ndk dependencies
import nfs
# Module dependencies
import ./types/glsl

#_______________________________________
# Generate GLSL
#___________________
template gen *(shader :typed; typ :ShaderType; name, trg :string; vers :string= "460 core"; v :bool= true) :void=
  ## Converts the given shader AST into GLSL at compile time. (cannot be runtime)
  ## Its output will be stored in trg folder, with filename `name` and the correct extension for `typ`.
  ## Will use glsl version `460 core` if not specified.
  ## The folder tree will be created, unless it already exists.
  ## The contents of the file will be overwritten if it already exists.
  # Create the target folder if it doesn't exist
  md trg, v
  # Generate the shader code
  let ext  = "." & normalize($typ)
  let code = shader.toGLSL(vers)
  let file = trg/name&ext
  file.writeFile(code)
#___________________
template genProgram *(vert, frag :typed; name, trg :string; vers :string= "460 core"; v :bool= true) :void=
  ## Converts the given vert and frag ASTs into GLSL at compile time. (cannot be runtime)
  ## The output files will be stored in trg folder, with filename `name` and the correct extensions for each type.
  ## Will use glsl version `460 core` if not specified.
  ## The folder tree will be created, unless it already exists.
  ## The contents of the files will be overwritten if they already exist.
  vert.gen(Vert, name, trg, vers, v)
  frag.gen(Frag, name, trg, vers, false)


when isMainModule:
  proc circle *(
      gl_FragColor :var Vec4;
      uv           :Vec2;
      time         :Uniform[float32] ) =
    var radius = 300.0 + 100 * sin(time)
    if uv.length < radius:
      gl_FragColor = vec4(1, 1, 1, 1)
    else:
      gl_FragColor = vec4(0, 0, 0, 1)

  echo "-> Starting..."
  let dir = "."/"shd"
  rm dir
  circle.gen(Frag, "generated", dir, v = false)
  genProgram(circle, circle, "generated2", dir)
  echo "-> Finished."


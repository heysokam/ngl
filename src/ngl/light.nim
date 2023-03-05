#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# ndk dependencies
import nstd/types
import nmath
# Module dependencies
import ./types/light
import ./types/shader as shdType
import ./color
import ./shader
import ./uniform

#____________________
proc newLight *(
     kind   :LightKind= LightKind.Pt;
     color  :Color=     color(1,1,1,1);
     power  :f32=       1;
     pos    :Vec3=      vec3(0,0,0);
     dir    :Vec3=      vec3(0,0,0);
     active :bool=      false;
     sttic  :bool=      false
     ) :Light=
  ## Initializes a light of the given properties
  ## Defaults to disabled white dynamic point light with a power of 1, if no properties are specified
  case kind:
  of   LightKind.Amb : result = Light(kind: kind)
  of   LightKind.Pt  : result = Light(kind: kind, posv: pos)
  of   LightKind.Dir : result = Light(kind: kind, dirv: dir)
  of   LightKind.Spot: result = Light(kind: kind, sdirv: dir, sposv: pos)
  if not active: result.flags.incl(LightFlag.ina)
  result.power  = power
  result.color  = color
#____________________

#______________________________
# TODO: Should be unified with the Light type
# TODO: Structs should be UBOs, not seq[uniforms] or hardcoded multiuniform objects
# TODO: Upload UBO with explicit layout(binding = X)   ? can single uniforms use binding ?
#______________________________
proc register *(lt :var LightUniform; shd :ShaderProg) :void=
  ## Initializes the id of the light from the given shader, searching the uniform by name
  if not lt.active: return
  lt.color.register(lt.name&".color", shd)
  lt.power.register(lt.name&".power", shd)
  lt.pos.register(  lt.name&".pos",   shd)
  lt.dir.register(  lt.name&".dir",   shd)
#______________________________
proc enable *(lt :var LightUniform) :void=
  ## Uploads the light.data to OpenGL
  ## Requires that the light has been initialized
  ## Won't do anything if the light is marked inactive
  if not lt.active: return
  lt.color.enable
  lt.power.enable
  lt.pos.enable
  lt.dir.enable

#______________________________
proc newLight *(
      name     :str,
      color    :Color= color(1,1,1,1);
      power    :f32= 1;
      pos      :Vec3= vec3(0, 0,0);
      dir      :Vec3= vec3(0,-1,0);
      active   :bool= false,
      enable   :bool= false,
      register :bool= false,
      shd      :ShaderProg= ShaderProg(id:0)
      ) :LightUniform=
  ## Initializes a new light uniform with the given properties
  ## If enable=false, the data will only be stored inside the object
  ## A valid/existing ShaderProg must be given when register=true
  # TODO: Error checking. This can fail big time
  # TODO: MultiLight support
  result.name   = name
  result.active = active
  result.power  = power.uniform
  result.color  = color.uniform
  result.pos    = pos.uniform
  result.dir    = dir.uniform
  if register: result.register(shd)
  if enable:   result.enable


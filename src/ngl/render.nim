#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# External dependencies
import pkg/chroma
# ndk dependencies
import nmath
# Module dependencies
import ./types/profile
import ./types/core
import ./types/window
import ./types/camera


#____________________
# Renderer Tools
#____________________
proc newRenderer *(prof :RenderProfile= RenderProfile()) :Renderer=
  ## Creates a new object, with all values set to 0 or empty
  let name = "Renderer New (uninitialized)"
  new result
  result = 
    Renderer(win:     Window(ct: nil, size: uvec2(0,0), title: name),
             cam:     Camera(pos: vec3(), rot: vec3(), up: vec3(), fov: 0.0'f32, near: 0.0'f32, far: 0.0'f32),
             bg:      color(0, 0, 0, 1),
             profile: prof,
             )


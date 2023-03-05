# Nim Graphics Library
Cohesive graphics API layer on top of other tools.  

Targets modern tech:  
- OpenGL core 4.6, no backwards compat  
  Uses DSA, Compute and many other 4.6-only features.

Almost a renderer:  
- Provides notions of data beyond what a pure API would.  
- Doesn't try to be agnostic or generalistic.  
- One single purpose: Tools to create a good renderer.  

Not reinventing the wheel for the 1000st time:  
`glfw`   for window creation
`shady`  for shaders
`vmath`  for vector math
`chroma` for colors
`pixie`  for textures
`boxy`   for GPU images and rect-packing
`nstd`   for system extensions

**Current state**:  
Custom OpenGL API, for ergonomics and naming.  

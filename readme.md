# Nim Graphics Library
Cohesive graphics API layer, built on top of other tools.  

Not agnostic. Almost a renderer:  
- Provides notions of data beyond what a pure API would.  
- Doesn't try to be agnostic or generalistic.  
- One single purpose: Tools to create a good renderer.  

Targets modern tech:  
- OpenGL core 4.6, no backwards compat  
  DSA-only. No support for pre-DSA code.  
  Compute shaders and many other gl4+ features.  
- Modern means 2015+ hardware, not 2000's version of "modern".  

Not reinventing the wheel:  
`glfw`   for window creation  
`shady`  for shaders  
`vmath`  for vector math  
`pixie`  for textures  
`boxy`   for GPU images and rect-packing  
`chroma` for colors  

**Current state**:  
Custom OpenGL API, for ergonomics and naming.  
See the [examples](./examples) folder for a reference of the current state of the lib.  


## Default OpenGL config
- Vertex are expected in CCW order.  
- Backfaces are culled.  
- Color buffer is cleared at the start of each frame.  
  - Debug:   Will clear to Pure Magenta.  
  - Release: Will clear to 0.1gray.  
- Depth buffer is cleared at the start of each frame.  
- Shaders:
  - Read from `.vert`, `.frag`, `.tess` and `.comp` files.  
  - Name formatting:
    - Attributes:      `aTheName`
    - Uniforms:        `uTheName`
    - Vertex/Varyings: `vTheName`
    - Fragments:       `fTheName`

## Syntax and usage
See the [examples](./examples/) folder for how the library is used.  
Each example has an `-unroll`ed version, that achieves the exact same functionality as the rolled version. Internal function names are added as comments, to showcase how the flow of the code runs inside the library.  

Note on the `-unroll`ed examples:
_Unrolling the library objects/types made the syntax much more verbose than it actually is internally. Verbosity is considered undesirable by the design style of this lib. This effect is created by the unrolling process, and is not representative of the actual code._  
_This issue could be fixed (in the unrolled versions) by having many global variables to store the state of the data, instead of using `RenderMesh`, etc. In this way, each variable would be accessed directly, without having to name all its parents everytime something is called. But this is not needed in normal usage of the lib._  
_The unrolled examples chose this style with the goal of capturing the actual flow of data inside the library._  
_Internally, functions pass the sub-object to each step, and objects are created with their constructors, so this issue does not happen._  


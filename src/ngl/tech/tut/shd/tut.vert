//_______________________________________________________________________
//  Reid Engine : Copyright (C) Ivan Mar (sOkam!) : GNU GPLv3 or higher |
//______________________________________________________________________|

#version 460 core

// Vertex inputs (Attributes)
//______________________________
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec4 aColor;
layout (location = 2) in vec2 aUV;
layout (location = 3) in vec3 aNorm;

// Vertex shader outputs (varyings)
//______________________________
// Represents a set of values for the current fragment
// Numbers are interpolated based on vertex information
// Writable in the vertex, and read-only in the fragment
//______________________________
out vec3 vPos;    // Vertex position
out vec4 vColor;  // Vertex color
out vec2 vUV;     // Vertex UV coord
out vec3 vNorm;   // Vertex normal

// Uniforms
//______________________________
// Read-only Global variables that may change per primitive.
// Passed from the application to the shader.
// Can be used in both vertex and fragment shaders
//______________________________
uniform mat4  uWVP;    // Transformation matrix
uniform vec4  uColor;  // Tut: Incoming Constant Color  TODO: Probably remove

// Entry point
//______________________________
// Per-vertex operation
// for each vertex do main()
//______________________________
void main() {
  vPos   = aPos;    // Send attribute vertex position to the fragment shader
  vColor = aColor;  // Send attribute vertex color    to the fragment shader
  vUV    = aUV;     // Send attribute UV coordinates  to the fragment shader
  vNorm  = aNorm;   // Send attribute Surf Normal v3  to the fragment shader
  gl_Position = uWVP * vec4(aPos, 1.0);
}


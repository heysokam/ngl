//_______________________________________________________________________
//  Reid Engine : Copyright (C) Ivan Mar (sOkam!) : GNU GPLv3 or higher |
//______________________________________________________________________|

#version 460 core

// Fragment shader outputs
out vec4 fColor;

// Fragment shader inputs (varyings)
//______________________________
// Data interpolated between fragment and vertex shader
// Writable in the vertex, and read-only in the fragment
//______________________________
in vec4 vColor;
in vec2 vUV;

// Uniforms
//______________________________
// Read-only Global variables that may change per primitive.
// Passed from the application to the shader.
// Can be used in both vertex and fragment shaders
//______________________________
uniform mat4 uMVP;
uniform vec4 uColor;
uniform sampler2D uDif;

void main() {
  vec4 discardUV = texture2D(uDif, vUV);
  fColor = vColor;
}


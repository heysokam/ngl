//_______________________________________________________________________
//  Reid Engine : Copyright (C) Ivan Mar (sOkam!) : GNU GPLv3 or higher |
//______________________________________________________________________|

#version 460 core

//________________________________________________
// Types
//______________________________
struct  Light {
  float power;
  vec4  color;
  vec3  pos;
  vec3  dir;
};

//______________________________________
// Utils
//______________________________
#define PI 3.1415926535897932384626433832795
vec3  lin2rgb(vec3 lin)     { return pow(lin, vec3(1.0/2.2)); }  // Approx Linear to sRGB conversion
vec3  rgb2lin(vec3 rgb)     { return pow(rgb, vec3(    2.2)); }  // Approx sRGB to Linear conversion
float zdot(vec3 a, vec3 b)  { return max(dot(a,b), 0.0); }       // Returns a dot b, clamped to a mimimum of 0
float nzdot(vec3 a, vec3 b) { return max(dot(a,b), 0.00001); }   // Returns a dot b, clamped to a mimimum of 0.00001 to avoid div by 0
float sqr(float number)     { return number*number; }            // Returns the number squared
float area(float radius)    { return 4.0*PI*sqr(radius); }       // Returns the area of the sphere represented by the given radius
//________________________________________________


// Fragment shader outputs
//______________________________
out vec4 fColor;

// Fragment shader inputs (varyings)
//______________________________
// Represents a set of values for the current fragment
// Numbers are interpolated based on vertex information
// Writable in the vertex, and read-only in the fragment
//______________________________
in vec3 vPos;    // Vertex position
in vec3 vColor;  // Vertex color
in vec2 vUV;     // Vertex UV coord
in vec3 vNorm;   // Vertex normal

// Uniforms
//______________________________
// Read-only Global variables that may change per primitive.
// Passed from the application to the shader.
// Can be used in both vertex and fragment shaders
//______________________________
uniform mat4 uWVP;    // Transformation matrix
uniform vec4 uColor;  // Tut: Incoming Constant Color  TODO: Probably remove
uniform vec3 uCamPos; // Camera position in world space
//______________________________
uniform Light uLightAmb;
uniform Light uLightDir;
//______________________________
// Material data
uniform sampler2D uDif;     // Diffuse texture
uniform vec4      uMatAmb;  // Material Ambient  color  TODO: Move to mat struct
uniform vec4      uMatDif;  // Material Diffuse  color  TODO: Move to mat struct
uniform vec4      uMatSpe;  // Material Specular color  TODO: Move to mat struct
const   float     uMatShi = 80.0;  // Material Shininess exp   TODO: Move to mat struct, probably mat.spe.a

//________________________________________________
// Indirect Lighting
//______________________________
vec4 ambient(vec4 matColor, Light amb) {
  return vec4(amb.color.rgb * amb.power * matColor.rgb, 
              amb.color.a   * matColor.a);  // Scale color by power, ignoring alpha
}
//______________________________
vec4 indirect(vec4 texDiffuse) {
  // Calculate ambient color
  return ambient(texDiffuse*uMatDif, uLightAmb);
}
vec4 direct(vec4 texDiffuse) {
  // Calculate directional light
  vec3  N          = normalize(vNorm);  // Surface Normal
  vec3  L          = uLightDir.dir;     // Light Direction
  float difFactor  = zdot(N,-L);        // Lambert's Cosine Law (Diffuse Factor)
  vec3  lightColor = vec3(uLightDir.color.rgb * uLightDir.power);      // Scale color by power, ignoring alpha
  vec4  surfColor  = vec4(lightColor * difFactor, uLightDir.color.a);  // Reduce light color by the Lambert's factor
  // Calculate the final diffuse color
  vec4  dif        = texDiffuse * uMatDif * surfColor;

  // Calculate the specular color  (Phong reflection)
  // specular = dot(reflected_light, pixel_to_cam).pow(specular_exponent) * MatSpecular * LightColor
  vec3 V   = normalize(uCamPos-vPos); // View Direction
  vec3 R   = reflect(-L,N);           // Perfect Reflection Direction = Light Direction reflected on the Surface Normal
  vec4 spe = pow(zdot(R,V), uMatShi) * uMatSpe * vec4(lightColor, 1.0);

  return dif + spe;
}
//______________________________
void main() {
  // Apply the result color to this fragment
  vec4 texDiffuse = texture2D(uDif, vUV);  // Diffuse Color of this texel
  fColor = direct(texDiffuse) + indirect(texDiffuse);
  // fColor = vec4(vNorm, 1); // Debug normals
}

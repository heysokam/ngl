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

//________________________________________________
// Utils
//______________________________
#define PI 3.1415926535897932384626433832795
vec3  lin2rgb(vec3 lin)     { return pow(lin, vec3(1.0/2.2)); }  // Approx Linear to sRGB conversion
vec3  rgb2lin(vec3 rgb)     { return pow(rgb, vec3(    2.2)); }  // Approx sRGB to Linear conversion
float zdot(vec3 a, vec3 b)  { return max(dot(a,b), 0.0); }       // Returns a dot b, clamped to a mimimum of 0
float nzdot(vec3 a, vec3 b) { return max(dot(a,b), 0.00001); }   // Returns a dot b, clamped to a mimimum of 0.00001 to avoid div by 0
float sqr(float number)     { return number*number; }            // Returns the number squared
float area(float radius)    { return 4.0*PI*sqr(radius); }       // Returns the area of the sphere represented by the given radius
                                                                 //
//________________________________________________
// Fragment shader outputs
//______________________________
out vec4 fColor;


//________________________________________________
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


//________________________________________________
uniform vec3  lightPos;
uniform vec3  camPos;      // Position of the camera in world space
uniform float lightPower;  // description="Light Flux power" defaultval="3.0"
uniform vec4  ambColor;    // description="Ambient Light Color" defaultval="0.1, 0.1, 0.1, 1.0"

//________________________________________________
// Uniforms
//______________________________
// Read-only Global variables that may change per primitive.
// Passed from the application to the shader.
// Can be used in both vertex and fragment shaders
//______________________________
uniform mat4 uMVP;    // Transformation matrix
uniform vec4 uColor;  // Tut: Incoming Constant Color  TODO: Probably remove
//______________________________
uniform Light uLightAmb;
uniform Light uLightDir;
uniform int   uLightCount;
//______________________________
// Material data
uniform sampler2D uDif;     // Diffuse texture
uniform vec4      uMatAmb;  // Material Ambient  color  TODO: Move to mat struct
uniform vec4      uMatDif;  // Material Diffuse  color  TODO: Move to mat struct
uniform vec4      uMatSpe;  // Material Specular color  TODO: Move to mat struct
uniform float     uMatShi;  // Material Shininess factor TODO: Move to mat struct, probably uMat.spe.a


//________________________________________________
// BRDF
//______________________________
vec3 phong(vec3 L, vec3 V, vec3 N, vec3 Kd, vec3 Ks, float Kn) {
  // Standard Phong Reflection Model
  vec3 dif = Kd;
  vec3 R   = reflect(-L,N);  // Perfect Reflection Direction = Light Direction reflected on the Surface Normal
  vec3 spe = Ks * pow(zdot(V,R), Kn;
  return dif + spe;
}
//______________________________
vec3 phongMod(vec3 L, vec3 V, vec3 N, vec3 Kd, vec3 Ks, float Kn) {
  // Modified Phong Reflection Model
  // Specular is normalized, and the sum of dif+spe will be <= 1
  vec3  dif = Kd / PI;
  vec3  R   = reflect(-L,N);        // Perfect Reflection Direction = Light Direction reflected on the Surface Normal
  float nor = (Kn+2.0) / (2.0*PI);  // Normalization factor
  vec3  spe = Ks * pow(zdot(V,R), Kn) * nor;
  spe = min(spe, 1.0-dif);
  return dif + spe;
}
//______________________________
vec3 blinn(vec3 L, vec3 V, vec3 N, vec3 Kd, vec3 Ks, float Kn) {
  // Blinn Reflection Model
  vec3 dif = Kd;
  vec3 H   = normalize(V+L);  // Halfway Direction between View and Light directions
  vec3 spe = Ks * pow(zdot(H,N), Kn);
  return dif + spe;
}


//________________________________________________
// Direct Lighting
//______________________________
vec3 direct() {
  vec3  Kd = rgb2lin(uMatDif.rgb);                       // Diffuse  Material Color
  vec3  Ks = rgb2lin(uMatSpe.rgb);                       // Specular Material Color
  float Kn = uMatShi;                                    // Shininess Material property
  vec3  V  = normalize(camPos-vPos);                     // View Direction
  vec3  O  = vec3(0);                                    // Final total Radiance
  for (int it; it < uLightCount; it++) {                 // For every light
    vec3  L  = lightPos - vPos;                          // Light Direction
    float lightDist = length(L);                         // Distance from surface to light position
    L = normalize(L);                                    // Light is a Direction, so normalize it
    vec3  N  = normalize(vNorm);                         // Surface Normal
    vec3  B  = blinn(L,V,N,Kd,Ks,Kn);                    // Material BRDF, calculated with [...] material model
    float I  = zdot(L,N) * lightPower / area(lightDist); // Irradiance
    O += I*B;                                            // BRDF * Irradiance = Direct Radiance contribution of this light 
  }
  return lin2rgb(O);
}


//________________________________________________
// Indirect Lighting
//______________________________
vec3 ambient(vec3 Kd, Light amb) { 
  vec4 trgAmb = vec4(uLightAmb.color.rgb * uLightAmb.power * uMatAmb.rgb, 
                     uLightAmb.color.a   * uMatAmb.a);  // Scale color by power, ignoring alpha

  return rgb2lin(Kd) * rgb2lin(amb.color); 
}  // Ambient = diffuse * ambient
//______________________________
vec3 indirect() {
  return lin2rgb(ambient(uMatDif.rgb, ambColor));
}

//________________________________________________
void main() {
  fColor = vec4(direct() + indirect(), uMatDif.a);
}


//_______________________________________________________________________
//  Reid Engine : Copyright (C) Ivan Mar (sOkam!) : GNU GPLv3 or higher |
//______________________________________________________________________|

#version 460 core

//________________________________________________
// Notes from:
// https://www.youtube.com/watch?v=esC1HnyD9Bk
//________________________________________________


//________________________________________________
// C  | Color output of the fragment
// I  | Light Intensity | Determines the amount of light that is seen
//________________________________________________
// ω  | Light Direction |  Omega Ω ω
// ωn | Light Direction for light number n
// L  | Light Amount
//________________________________________________
// s  | Surface Area
// N  | Surface Normal
// θ  | Angle between ω and N  |  Theta θ
//________________________________________________
// N == ω           | When light comes exactly from above surface
// s increases      | The more light N and ω point at different directions
// L decreases      | The bigger theta is, the less light per unit we get.
//                  | Result: We get less light per unit area.
// L / s            | The bigger s is, the less L amount we get
// cosθ = 1/s       | Geometry term. Amount of L per unit area
// L/s = L*cosθ     | Light amount * Geometry term = Amount of light per area on the surface.
//________________________________________________
// Kd               | Diffuse Material Constant (property)
// Kd*cosθ          | Surface color
// dot(N, ω)        | Same as cosθ, when N and ω are normalized
// max(0, dot(N,ω)) | cosθ can be negative, and should give 0 influence in those cases.
// Kd*dot(N,ω)      | Simplified surface color
//                  | Kd*cosθ == Kd*dot(N,ω)  
//________________________________________________
// I*Kd*cosθ == C   | Lambertian (Diffuse) Material color
// I*Kd*dot(N,ω)    | Simplified Diffuse Material
vec3 diffuse(vec3 intensity, vec3 diffuse, vec3 surfNorm, vec3 lightDir) {
  vec3 geoTerm = max(0, dot(surfNorm, lightDir));
  return intensity * diffuse * geoTerm;
}  //________________________________________________

//________________________________________________
// Diffuse          | Rays scatter equally, regardless of the observer point of view.
// Specular         | Rays emerge at the same angle than the source, but on the opposite side of the light.
//________________________________________________
// No Diffuse == No Specular == 0 == Black
// I * 0 reflection == Black
//________________________________________________


//________________________________________________
// Ks               | Specular  Material Constant (property)
// α                | Shinyness Material Constant (property)
// V                | View direction
// R                | Reflection direction of Light direction ω  (Perfect Reflection)
//   2*(dot(ω,N)*N-ω == -reflect(ω,N)
// φ                | (Phong) Angle between V and R | Phi φ
// cosφ             | Separation amount between V and R
// dot(V,R)         | Same as cosφ, when V and R are normalized
float phongPhi(vec3 surfNorm, vec3 lightDir, vec3 viewDir) {
  return dot(viewDir, -reflect(lightDir, surfNorm));
} //________________________________________________

//________________________________________________
// Phong Reflect    | Phi will dictate the amount of Ks that we get
//   I*Ks*(cosφ)^α == I*Ks*(dot(V,R))^α
vec3 phongReflect(vec3 intensity, vec3 specular, vec3 phi, float shinyness) {
  return intensity * specular * pow(phi, shinyness)
} //________________________________________________

//________________________________________________
// Cp               | Resulting Phong Color (C)
// Cp = Diffuse       + Specular
// Cp = I*Kd*max(0,dot(N,ω)) + I*Ks*(max(0,dot(V,R)))^α
// Cp = I * (Kd*max(0,dot(N,ω)) + Ks*(max(0,dot(V,R)))^α)  // Original phong representation, with hidden geometry term
// Cp = I*max(0,dot(N,ω)) * (Kd + Ks*(max(0,dot(V,R)))^α)  // Modified phong, without the hidden cosθ (geometry term)
// Cp = I*max(0,dot(N,ω)) * (Kd + Ks*( max(0,dot(V,R)))^α / dot(N,ω) )   // True phong, including geometry term
//________________________________________________
vec3 phong() {
  return diffuse(intensity, difColor, surfNorm, lightDir) 
       + phongReflect(intensity, specular, phongPhi(surfNorm, lightDir, viewDir), shinyness)
       + ambient(ambColor);
}


//________________________________________________
// H                | Direction of the HalfVector. Exactly in between V and ω
//   normalize(ω+V) == ω+V / length(ω+V)
// φ                | (Blinn) Angle between N and H | Phi φ
float blinnPhi(vec3 surfNorm, vec3 lightDir, vec3 viewDir) {
  return dot(surfNorm, normalize(lightDir, viewDir));
} //________________________________________________

//________________________________________________
// Blinn Reflect    | Half Vector dictates the amount of Ks that we get (instead of R)
//   I*Ks*(cosφ)^α == I*Ks*(dot(N,H))^α
//________________________________________________
// Cb               | Resulting Blinn Color (C)
// Cb = I*max(0,dot(N,ω)) * (Kd + Ks*( max(0,dot(N,H)))^α / dot(N,ω) ) // Same as True Phong, but with different Phi
//________________________________________________

//________________________________________________
// Blinn vs Phong   | Phi is the only difference, the rest is the exact same.
//________________________________________________

//________________________________________________
// Ka               | Ambient Material Constant (property)
//   Ka ~eq~ Kd     | Can make sense to make the ambient color equal the diffuse color of the surface.
// Ia               | Ambient Light Intensity
// C = BlinnPhong + Ia*Ka
//________________________________________________


//________________________________________________
// Full process
//__________________
// CPU:
//   ModelView               (4x4) | To take positions into ViewSpace
//   ModelViewProjection     (4x4) | To take positions into Canonnical View Volume (ClipSpace)
//   ModelView (for normals) (3x3) | To take normals into ViewSpace, with correct scaling
//__________________
// Vertex Shader:
//   Trasform position with ModelView               (for calculating the view direction vector)
//   Trasform position with ModelViewProjection     (for rasterization)
//   Trasform position with ModelView (for normals)
//__________________
// Fragment Shader:
//   Calculate Lighting and Shading
//________________________________________________|




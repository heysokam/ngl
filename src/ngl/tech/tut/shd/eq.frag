// O  : Final Color : Outgoing light that will hit the camera Lo(x,V)
// V  : View direction
// E  : Light emitted by the object
// Z  : Sum of all lights affecting the point
// Zn : Part of the sum contributed by the n'th light
// B  : BRDF : Bidirectional Reflectance Distribution Function
// L  : Light vector
// Ln : Light vector of the n'th light
// N  : Surface Normal
// R  : Perfect Reflection direction
// H  : Halfway vector. Vector exactly in between L and R
// G  : Geometry term of the light. Ln dot Norm
//    : Less light the farther L and N are from each other
//    : Light is spread across a bigger area, so less L per unit area
O(x,V) = E(x,V) + Zn[ B(x,Ln,V) * I(x,Ln) * G(Ln,N) ]
// K  : Fraction of light contributed by a specific material property.
//    : PBR conserves energy, sum of all K must be 1  :  sum[K] == 1
//    : If the sum is above 1, energy is being created from nowhere, which is not physically real.
// Ks : Fraction of light contributed by the specular material property
// F  : Fresnel effect dictates the amount of specular reflection
//    : Ks = Fresnel factor
// Fn : Reflectivity
// Kd : Fraction of light contributed by the diffuse material property
//    : Since sum needs to be 1, Kd = 1-Ks
B = Kd*diffuse + Ks*specular
F.schlick = R + (1-R) * (1-(V*H))^5

// Most technical explanation found:  https://www.youtube.com/watch?v=kqOnLErkGYw

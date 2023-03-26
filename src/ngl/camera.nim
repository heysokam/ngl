#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# ndk dependencies
import nstd/types  as base
import nmath
# Module dependencies
import ./types


# TODO: CRITICAL
#       Keep camera+body transforms in sync
#       Also, change the camera to use transform instead of vectors
#

#__________________________________________________
proc newCamera *(origin, target, up :Vec3; fov, near, far :f32) :Camera=
  result.rot  = origin.lookAt(target, up).angles #vec3(0,0,0) #origin.lookAt(target, up).hrp
  result.pos  = origin
  result.up   = up
  result.fov  = fov
  result.near = near
  result.far  = far 

#____________________
proc view *(cam :Camera) :Mat4=
  # TODO: Should be :  result = cam.trf.mat4   instead
  let rotation :Mat4=  cam.rot.yaw.rotateY * cam.rot.pitch.rotateX
  result = cam.pos.translate * rotation
#____________________
# Perspective Projection Matrix                       fov Y    aspect ratio  near  far
proc proj *(cam :Camera; ratio :f32) :Mat4=  perspective(cam.fov, ratio, cam.near, cam.far)


#____________________
template init *(origin, target, up :Vec3; fov, near, far :f32) :Camera=  newCamera(origin, target, up, fov, near, far)
template dir  *(cam :Camera) :Vec3= cam.pos.target
#__________________________________________________
proc reset *(cam :var Camera; pos :Vec3) :void=
  cam.pos    = pos
  let target = vec3(0,0,0)  # TODO: Get LookTarget also from the SpawnPoint
  let up     = vec3(0,1,0)  # todo: Allow custom up vector in the map file, when we can afford changing it
  cam.rot    = cam.pos.lookAt(target, up).angles

#____________________
template move *(cam :Camera; vel :Vec3) :void=
  cam.pos += cam.rot.target * vel
  # cam.target += vel



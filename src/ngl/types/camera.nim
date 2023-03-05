#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# ndk dependencies
import nstd/types  as base
import nmath/types as m

#____________________
## Camera
type Camera * = object
  pos   *:Vec3  ## Position / Origin point of the camera
  rot   *:Vec3  ## X/Y/Z angles of rotation (yaw, pitch, roll)
  up    *:Vec3  ## Up direction for the camera (in world space)
  fov   *:f32   ## fov Y angle in degrees (vmath format)
  near  *:f32   ## Nearest  distance that the camera can see
  far   *:f32   ## Farthest distance that the camera can see
type Cameras * = seq[Camera]


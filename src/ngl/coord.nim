#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# ndk dependencies
import nmath
# Module dependencies
import ./types/coord

#______________________________
# Handiness rule wtf:
#   You can draw a -left- handed system with your RIGHT hand
#    by rotating the Right-handed OpenGL basis 90deg forwards along the X axis (pitch)
#   The rule only works intuitively for finding the sign of angles, and the direction of a cross product
#    but NOT for coordinate systems.
#   Rotating the same hand can swap the handiness of the system, which makes this rule extremely confusing
#   To reproduce this:
#   1. Draw a right handed OpenGL system with your right hand.
#      Thumb pointing right is +X, index pointing up is +Y, middle pointing behind us / back is +Z
#   2. Place the back of your hand on the table, without swapping the axis signs or order that your fingers represent
#      Thumb  is still +X, points in the same direction  (we rotated along this axis)
#      Index  is still +Y, points forwards               (this axis was rotated from up to forward, and now lies on the table)
#      Middle is still +Z, points upwards                (this axis was lifted away from us, and now points upwards)
#   3. You are now drawing the text-book definition of a left handed coordinate system with your right hand (:facepalm:)
#______________________________

#______________________________
# Game coordinates  (+Z.up, +Y.forw, +X.right)
const left   = -1  # X
const right  =  1  # X
const forw   =  1  # Y
const back   = -1  # Y
const up     =  1  # Z
const down   = -1  # Z
#______________________________
const GameCoords *:Coords= Coords(  # Game coordinates 
  # Axis     Movement           Rotation
  X:Axis(pos:right, neg:left),  # Pitch
  Y:Axis(pos:forw,  neg:back),  # Roll
  Z:Axis(pos:up,    neg:down))  # Yaw
#______________________________
# Rotating the GameCoords basis matrix swaps the sign of back/forw   (aka pitching forwards/down)
# (aka rotating 90deg around X, away from us, so that +Z becomes up instead of back) 
const forwGL = -1  # Z
const backGL =  1  # Z
#______________________________
const OpenGLCoords *:Coords= Coords(  # OpenGL right-handed coordinates
  # Axis     Movement              Rotation
  X:Axis(pos:right,  neg:left),    # Pitch
  Y:Axis(pos:up,     neg:down),    # Yaw
  Z:Axis(pos:forwGL, neg:backGL))  # Roll
#______________________________
template swapYZ *(m :Mat4) :Mat4=
  ## Swap Y/Z axis of the matrix (row major, translation at bottom row)
  ## Converts OpenGLCoords to/from GameCoords coordinates (Change of basis)
  ## Note: Don't use handiness to understand or describe this conversion.
  ##       It doesn't work. (read coord.nim file for details)
  mat4(
  vec3( m[0][0],  m[0][1],  m[0][2],  m[0][3]),  # X   row  unchanged
  vec3( m[2][0],  m[2][1],  m[2][2],  m[2][3]),  # Z   row  becomes the Y row
  vec3( m[1][0],  m[1][1],  m[1][2],  m[1][3]),  # Y   row  becomes the Z row
  vec3( m[3][0],  m[3][2],  m[3][1],  m[3][3])   # Translate x,y,z. Swaps Y/Z
  )

#______________________________
# Gameplay-oriented coordinate system:
#   +X values: to the right of the origin
#   +Y values: in front of the origin
#   +Z values: above the origin
#   Negative x, y, and z values indicate left, behind and below the origin, respectively.
# Gameplay: -X.left +Y.forw -Z.down    2D: -X.left -Y.down
# OpenGL:   -X.left +Y.up   -Z.forw    2D: -X.left -Y.down
#______________________________

#______________________________
# The handiness is Right when:
#   dot(Z, cross(X,Y)) ==  1
#   Means: The projection of Z and the perpendicular line to both (X,Y) is  1   (aka they point in the same direction)
# The handiness is Left  when:
#   dot(Z, cross(X,Y)) == -1
#   Means: The projection of Z and the perpendicular line to both (X,Y) is -1   (aka they point in opposite directions)
# The following operations switch handiness:
# - multiplying any axis by -1
# - swapping any two axis
#______________________________

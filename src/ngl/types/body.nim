#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# ndk dependencies
import nmath/types as m
# Module dependencies
import ./buffer
import ./material

#____________________
# Mesh / Model
type RenderMesh * = object
  ## Contains the data needed to draw a 3D model on the screen
  vao   *:VAO         ## Contains the vao.id and all VBO attributes data and metadata
  inds  *:Indices     ## Contains the EBO id and the indices data
  mats  *:Materials   ## Materials used by the mesh. Each material will be a seq of Textures
#____________________
type RenderModel * = seq[RenderMesh]

#____________________________________________________________
# Visual Body
type RenderBody *[T]= object
  ## Contains the data needed to draw a Visual Object on the screen
  ## Includes spatial data, such as position, rotation, scale
  ## Will use the configured Physics Type for its Transform
  mdl  *:RenderModel  ## Body Geometry data
  trf  *:Transform[T] ## Body 3D transformation data
#____________________
type RenderBodies * = seq[RenderBody]


#:___________________________________________________
#  ngl  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:___________________________________________________
# Module dependencies
import ./texture
import ./uniform


#____________________
type MatAttribute * = distinct float32
type MatType      * = enum Diffuse, Specular
#____________________
type Material * = object
  typ  *:MatType  ## Material type
  tex  *:Texture  ## Material texture, contains a K value for each pixel individually
  K    *:Uniform  ## Value property of the material, applied to the texture uniformly

#____________________
type Materials * = seq[Material]


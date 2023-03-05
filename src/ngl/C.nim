#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# ndk dependencies
import nstd/C/address ; export address
# Module dependencies
import ./types/buffer

#__________________________________________________
# C interfacing
# Conversion to ctypes from native engine data types
#____________________
template caddr   *(v :VBO|EBO) :pointer=  v.data[0].addr
template csizeof *(v :VBO|EBO) :cint=     (v.data[0].sizeof * v.data.len).cint
#____________________

#:_______________________________________________
#  ngl : Copyright (C) Ivan Mar (sOkam!) : MIT  :
#:_______________________________________________
# ndk dependencies
import nstd/C/address ; export address
# Module dependencies
import ./types/buffer

#__________________________________________________
# C interfacing
# Conversion to ctypes from our native data types
#____________________
template caddr   *(v :BO) :pointer=  v.data[0].addr
template csizeof *(v :BO) :cint=     (v.data[0].sizeof * v.data.len).cint


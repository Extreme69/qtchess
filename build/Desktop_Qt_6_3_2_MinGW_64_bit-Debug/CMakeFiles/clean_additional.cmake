# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles\\appchess_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\appchess_autogen.dir\\ParseCache.txt"
  "appchess_autogen"
  )
endif()

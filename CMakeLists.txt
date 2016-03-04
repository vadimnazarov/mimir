cmake_minimum_required(VERSION 2.8)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
project(Mimir CXX)

if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++11")
endif()

#add_subdirectory(Mimir)

#file(GLOB MimirSources "Mimir/src/*.h" "Mimir/src/*.cpp")
file(GLOB AppSources app/app.cpp source/selection/selection_model.h source/selection/selection_model.cpp)

include_directories(Mimir)
include_directories(include)

#add_library(Mimir STATIC Mimir/Model Mimir/Inference ${MimirSources})
add_executable(app ${AppSources})

#target_link_libraries(app Mimir)
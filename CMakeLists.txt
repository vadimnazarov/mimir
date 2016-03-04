cmake_minimum_required(VERSION 2.8)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")


project(Mimir)

file(GLOB MimirSources "Mimir/src/*.h" "Mimir/src/*.cpp")
file(GLOB AppSources "source/app/*.cpp")

include_directories(${CMAKE_SOURCE_DIR}/Mimir)
include_directories(${CMAKE_SOURCE_DIR}/app)
include_directories(include)

add_library(Mimir STATIC ${MimirSources})
add_executable(app app/app.cpp)

target_link_libraries(app Mimir)
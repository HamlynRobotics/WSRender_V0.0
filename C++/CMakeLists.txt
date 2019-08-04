cmake_minimum_required(VERSION 2.6)
project(workspace)

add_compile_options(-std=c++11)

find_package(Boost 1.58 REQUIRED)
find_package(Eigen3)
find_package(orocos_kdl)

find_package(catkin REQUIRED
  kdl_parser
  urdf
  eigen_conversions
)

include_directories(${orocos_kdl_INCLUDE_DIRS} ${EIGEN3_INCLUDE_DIRS})
include_directories( include ${catkin_INCLUDE_DIRS} ${Boost_INCLUDE_DIRS})

link_libraries(${catkin_LIBRARIES} ${Boost_LIBRARIES})
link_libraries(${orocos_kdl_LIBRARIES})

set(SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)
set(SOURCES 
   ${SRC_DIR}/main.cpp
   ${SRC_DIR}/robot.cpp
   ${SRC_DIR}/kdl_dynamics.cpp
   )
    

add_executable(workspace ${SOURCES})


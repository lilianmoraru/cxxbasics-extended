cmake_minimum_required(VERSION 3.6 FATAL_ERROR)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}")

# Add "cxxbasics_tidy_target"
include(tools/UseClangTidy)

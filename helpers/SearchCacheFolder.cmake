## This module identifies a user cache and sets CXXBASICS_CACHE_FOLDER to it, if it was
## not defined previously by the user(in the CMake cache)
##
## - If the cache folder is not writable, an error will be thrown and the user needs to fix the issue
## - If CXXBASICS_CACHE_FOLDER(passed by the user or detected here) is not a directory,
##   it will be unset

cmake_minimum_required(VERSION 3.8 FATAL_ERROR)

opt_ifndef("CXXBasics user cache"  PATH  ""  CXXBASICS_CACHE_FOLDER)
if(NOT DEFINED CXXBASICS_CACHE_FOLDER OR NOT IS_DIRECTORY "${CXXBASICS_CACHE_FOLDER}")
  # Lets make sure that the environment variables that we depend on, are set
  if(UNIX)
    if("$ENV{HOME}" STREQUAL "")
      cberror("\"$HOME\" environment variable is not set. Please set it")
    endif()
  elseif(CMAKE_HOST_WIN32)
    if("$ENV{LOCALAPPDATA}" STREQUAL "")
      cberror("\"%LOCALAPPDATA%\" environment variable is not set. Please set it")
    endif()
  endif()

  # Lets set the cache variable
  if(CMAKE_HOST_UNIX AND NOT CMAKE_HOST_APPLE)
    opt_overwrite(CXXBASICS_CACHE_FOLDER  "$ENV{HOME}/.cache")
  elseif(CMAKE_HOST_WIN32)
    file(TO_CMAKE_PATH "$ENV{LOCALAPPDATA}" __cxxbasics_windows_cache)
    opt_overwrite(CXXBASICS_CACHE_FOLDER  "${__cxxbasics_windows_cache}")
    unset(__cxxbasics_windows_cache)
  elseif(CMAKE_HOST_APPLE)
    opt_overwrite(CXXBASICS_CACHE_FOLDER  "$ENV{HOME}/Library/Caches")
  else()
    cbnok("Unknown HOST system. Can't set CXXBasics user cache folder")
  endif()
endif()

# Lets make sure that the cache folder exists and is indeed a directory type.
if(IS_DIRECTORY "${CXXBASICS_CACHE_FOLDER}")
  include(helpers/Asserts)

  cbmessage("Checking if CXXBASICS_CACHE_FOLDER is writable")
  CXXBASICS_ASSERT_WRITABLE_FOLDER("${CXXBASICS_CACHE_FOLDER}")
  cbok("Check passed: CXXBASICS_CACHE_FOLDER is set")
else()
  unset(CXXBASICS_CACHE_FOLDER CACHE)
  cbnok("CXXBASICS_CACHE_FOLDER is not a directory. The variable was unset")
endif()

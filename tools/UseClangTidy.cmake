# This module adds the "cxxbasics_tidy_target" macro
# This macro can always be used, even if ClangTidy is disabled or not found - it will be ignored in these situations
# CXXBASICS_USE_TIDY(BOOL) - enable or disable the ClangTidy target(disabled by default)
# CXXBASICS_TIDY_CHECKS(STRING) - configure the desired checks(uses a reasonable default)

cmake_minimum_required(VERSION 3.6 FATAL_ERROR)

opt_ifndef("Use clang-tidy"  BOOL  OFF  CXXBASICS_USE_TIDY)
if(CMAKE_HOST_UNIX AND CXXBASICS_USE_TIDY)
  find_program(__cxxbasics_tidy_path NAMES
      clang-tidy
      clang-tidy40 clang-tidy-4.0
      clang-tidy39 clang-tidy-3.9
      clang-tidy38 clang-tidy-3.8
      clang-tidy37 clang-tidy-3.7
      clang-tidy36 clang-tidy-3.6
      clang-tidy35 clang-tidy-3.5
      clang-tidy34 clang-tidy-3.4
  )

  if(__cxxbasics_tidy_path)
    opt_ifndef(
        "ClangTidy checks"
        STRING
        "-checks=-*,clang-analyzer-*,-clang-analyzer-cplusplus*"
        CXXBASICS_TIDY_CHECKS
    )

    macro(cxxbasics_tidy_target)
      if(${ARGC} LESS 1)
        cberror("\"cxxbasics_tidy_target\" called with incorrect number of arguments")
      endif()

      set_target_properties(${ARGV} PROPERTIES C_CLANG_TIDY   "${__cxxbasics_tidy_path};${CXXBASICS_TIDY_CHECKS}")
      set_target_properties(${ARGV} PROPERTIES CXX_CLANG_TIDY "${__cxxbasics_tidy_path};${CXXBASICS_TIDY_CHECKS}")
    endmacro(cxxbasics_tidy_target)

    cbok("ClangTidy was found and \"cxxbasics_tidy_target\" is now defined.")
  else()
    # We let the user always use this macro, even if ClangTidy is missing
    macro(cxxbasics_tidy_target)
    endmacro(cxxbasics_tidy_target)

    cbnok("ClangTidy was not found. \"cxxbasics_tidy_target\" will be ignored.")
  endif()
else()
  # We let the user always use this macro, even if ClangTidy was not activated
  macro(cxxbasics_tidy_target)
  endmacro(cxxbasics_tidy_target)
endif()

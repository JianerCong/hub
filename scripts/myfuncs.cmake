
# make cache variables for install destinations
include(GNUInstallDirs)
# include CMakePackageConfigHelpers macro
include(CMakePackageConfigHelpers)

function(my_add_package pkg version src)
  # package the library ${pkg} from sources $src (which is usually ${pkg}.cpp)
  # The header file of this package is assumed to be ${pkg}.h
  my_init_pkg_config_install_dir(${pkg})
  add_library(${pkg} STATIC ${src})
  my_add_dual_include(${pkg})
  my_create_and_install_config_file(${pkg})
  my_package_this_pkg(${pkg})
  my_write_version_file(${pkg} ${version})
endfunction()

function(my_init_pkg_config_install_dir pkg)
  set(my_pkg_config_install_dir
    "${CMAKE_INSTALL_LIBDIR}/cmake/${pkg}"
    PARENT_SCOPE
    )
endfunction()

function(my_package_this_target pkg mod)
  my_install_target(${mod})
  my_export_target_file(${mod} ${pkg})
endfunction()

function(my_package_this_pkg pkg)
  my_install_target(${pkg})
  my_export_pkg_file(${pkg})
endfunction()

function(my_install_target mod)
  # install the target and create export-set
  install(TARGETS ${mod}
    EXPORT ${mod}Targets
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    )

  # install header file
  install(FILES ${mod}.h DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
endfunction()

function(my_add_dual_include mod)
  # add include directories
  target_include_directories(${mod}
    PUBLIC
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>"
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
    )
endfunction()

function(my_create_and_install_config_file pkg)
  # create config file
  configure_package_config_file(${CMAKE_CURRENT_SOURCE_DIR}/Config.cmake.in
    "${CMAKE_CURRENT_BINARY_DIR}/${pkg}Config.cmake"
    INSTALL_DESTINATION ${my_pkg_config_install_dir}
    # NO_CHECK_REQUIRED_COMPONENTS_MACRO
    # ^^^^^^^^^^^^^^comment this out if you do not need check_required_components()
    )

  # install config files
  install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/${pkg}Config.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/${pkg}ConfigVersion.cmake"
    DESTINATION ${my_pkg_config_install_dir}
    )

endfunction()

function(my_write_version_file pkg version)
  # generate the version file for the config file
  write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/${pkg}ConfigVersion.cmake"
    VERSION "${version}"
    COMPATIBILITY AnyNewerVersion
    )
endfunction()

function(my_export_pkg_file pkg)
  # generate and install export file
  install(EXPORT ${pkg}Targets
    FILE ${pkg}Targets.cmake
    NAMESPACE ${pkg}::
    DESTINATION ${my_pkg_config_install_dir}
    )
  endfunction()

function(my_export_target_file mod pkg)
  # generate and install export file
  install(EXPORT ${mod}Targets
    FILE ${pkg}${mod}Targets.cmake
    NAMESPACE ${pkg}::
    DESTINATION ${my_pkg_config_install_dir}
    )
endfunction()



# create library
add_library(${mod} STATIC ${mod}.cpp)
add_library(${pkg}::${mod} ALIAS ${mod})
my_add_dual_include(${mod})

my_package_this_target(${pkg} ${mod})

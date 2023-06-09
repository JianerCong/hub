cmake_minimum_required(VERSION 3.20)
project(Hi)

message("🐸 start scripting")
function(streq s1 s2)
  if (s1 STREQUAL s2)
    message("✅️ OK ${s1} == ${s2}")
  else()
    message("❌️ Failed ${s1} != ${s2}")
  endif()
endfunction()

# insert file
set(f ${PROJECT_BINARY_DIR}/hi.txt)
file(WRITE ${f} "abc")
file(READ ${f} x)
message("Wrote and Read ${x} from file ${f}")
streq(${x} abc)

# append file
file(APPEND ${f} "abc")
file(READ ${f} x)
message("Wrote and Read ${x} from file ${f}")
streq(${x} abcabc)

set(f1 ${CMAKE_CURRENT_BINARY_DIR}/hi2.txt)
# set(f1 hi2.txt)

# config file
set(n 123)
file(CONFIGURE OUTPUT ${f1}
  CONTENT "I have @n@ apples"
)
file(READ ${f1} x)
message("Wrote and Read [${x}] from file ${f1}")
streq(${x} "I have ${n} apples")

# remove file

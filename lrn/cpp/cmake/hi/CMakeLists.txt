cmake_minimum_required(VERSION 3.20)
project(Hi)

message("🐸 start scripting")
function(chk_streq s1 s2)
  if (s1 STREQUAL s2)
    message("✅️ OK ${s1} == ${s2}")
  else()
    message("❌️ Failed ${s1} != ${s2}")
  endif()
endfunction()

function(chk_nexist f)
  if (EXISTS ${f})
    message("❌️ Failed file ${f} exists")
  else()
    message("✅️ OK file ${f} doesn't exist")
  endif()
endfunction()

function(chk_exist f)
  if (EXISTS ${f})
    message("✅️ OK file ${f} exists")
  else()
    message("❌️ Failed file ${f} doesn't exist")
  endif()
endfunction()

# insert file
set(f ${PROJECT_BINARY_DIR}/hi.txt)
file(WRITE ${f} "abc")
chk_exist(${f})
file(READ ${f} x)
message("Wrote and Read ${x} from file ${f}")
chk_streq(${x} abc)

# append file
file(APPEND ${f} "abc")
file(READ ${f} x)
message("Wrote and Read ${x} from file ${f}")
chk_streq(${x} abcabc)

set(f1 ${CMAKE_CURRENT_BINARY_DIR}/hi2.txt)
# set(f1 hi2.txt)

# config file
set(n 123)
file(CONFIGURE OUTPUT ${f1}
  CONTENT "I have @n@ apples"
)
chk_exist(${f1})
file(READ ${f1} x)
message("Wrote and Read [${x}] from file ${f1}")
chk_streq(${x} "I have ${n} apples")

# remove file
file(REMOVE_RECURSE ${f1})
chk_nexist(${f1})

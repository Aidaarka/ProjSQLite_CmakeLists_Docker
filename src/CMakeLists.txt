cmake_minimum_required(VERSION 3.18)


project(InternProj0SQLite3)


include_directories(${CMAKE_SOURCE_DIR})


add_definitions(-DSQLITE_THREADSAFE=0)
add_definitions(-DSQLITE_ENABLE_FTS4)
add_definitions(-DSQLITE_ENABLE_FTS5)
add_definitions(-DSQLITE_ENABLE_JSON1)
add_definitions(-DSQLITE_ENABLE_RTREE)
add_definitions(-DSQLITE_ENABLE_EXPLAIN_COMMENTS) 
add_definitions(-DHAVE_READLINE)



add_library(sqlite SHARED sqlite3.c sqlite3.h sqlite3ext.h)
add_executable(sqlite3 shell.c sqlite3.c sqlite3.h sqlite3ext.h)


find_package(readline)
target_link_libraries(sqlite3 readline)

if(UNIX)
  include(FindThreads)
  target_link_libraries(sqlite3 m ${CMAKE_THREAD_LIBS_INIT} ${CMAKE_DL_LIBS})
  install(TARGETS sqlite3 RUNTIME DESTINATION bin)
endif(UNIX)

if(WIN32)
  add_custom_command(TARGET sqlite POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:sqlite> ${CMAKE_BINARY_DIR}/sqlite3.exe
    DEPENDS sqlite
  )
  install(FILES sqlite3.exe DESTINATION bin)
endif(WIN32)

install(FILES sqlite3.h sqlite3ext.h DESTINATION include)
install(TARGETS sqlite3 LIBRARY DESTINATION lib ARCHIVE DESTINATION lib)

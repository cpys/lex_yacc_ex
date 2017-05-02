cmake_minimum_required(VERSION 3.3)

PROJECT(lex_yacc_ex)

#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
set(CMAKE_CXX_STANDARD 11)

include_directories(${PROJECT_SOURCE_DIR}/src)

set(OUTPUT ${PROJECT_SOURCE_DIR}/output)

FIND_PACKAGE(BISON)
FIND_PACKAGE(FLEX)
BISON_TARGET(ex_parser src/yacc.y ${OUTPUT}/yacc.tab.cpp DEFINES_FILE ${OUTPUT}/yacc.tab.h)
FLEX_TARGET(ex_lexer src/lex.l ${OUTPUT}/lex.yy.cpp)
#
ADD_FLEX_BISON_DEPENDENCY(ex_lexer ex_parser)
#
include_directories(${OUTPUT})


add_executable(lex_yacc_ex
        ${BISON_ex_parser_OUTPUTS}
        ${FLEX_ex_lexer_OUTPUTS})

find_library(LEX_LIB lex)
target_link_libraries(lex_yacc_ex ${lex})


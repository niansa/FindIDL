# Redistribution and use is allowed under the OSI-approved 3-clause BSD license.
# Copyright (c) 2018 Apriorit Inc. All rights reserved.

set(IDL_FOUND TRUE)

function(add_idl _target _idlfile)
    get_filename_component(IDL_FILE_NAME_WE ${_idlfile} NAME_WE)
    set(MIDL_OUTPUT_PATH ${CMAKE_CURRENT_BINARY_DIR}/Generated)
    set(MIDL_OUTPUT ${MIDL_OUTPUT_PATH}/${IDL_FILE_NAME_WE}_i.h)

    if(${CMAKE_SIZEOF_VOID_P} EQUAL 4)
        set(MIDL_ARCH win32)
    else()
        set(MIDL_ARCH x64)
    endif()

    add_custom_command(
       OUTPUT ${MIDL_OUTPUT}
       COMMAND midl.exe ARGS /${MIDL_ARCH} /env ${MIDL_ARCH} /nologo ${CMAKE_CURRENT_LIST_DIR}/${_idlfile} /out ${MIDL_OUTPUT_PATH} ${MIDL_FLAGS} /h ${MIDL_OUTPUT}
       DEPENDS ${CMAKE_CURRENT_LIST_DIR}/${_idlfile}
       VERBATIM
       )

    add_custom_target(${_target}_gen DEPENDS ${MIDL_OUTPUT} SOURCES ${_idlfile})
    add_library(${_target} INTERFACE  )
    add_dependencies(${_target} ${_target}_gen)
    target_include_directories(${_target} INTERFACE ${MIDL_OUTPUT_PATH})
endfunction()
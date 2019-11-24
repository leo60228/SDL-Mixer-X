option(USE_MIKMOD          "Build with MikMod library" OFF)
if(USE_MIKMOD)
    option(USE_MIKMOD_DYNAMIC "Use dynamical loading of MikMod" OFF)

    if(USE_SYSTEM_AUDIO_LIBRARIES)
        find_package(MikMod REQUIRED)
        message("MikMod: [${MikMod_FOUND}] ${MikMod_INCLUDE_DIRS} ${MikMod_LIBRARIES}")
        if(USE_MIKMOD_DYNAMIC)
            add_definitions(-DMIKMOD_DYNAMIC=\"${MikMod_DYNAMIC_LIBRARY}\")
            message("Dynamic MikMod: ${MikMod_DYNAMIC_LIBRARY}")
        endif()
    else()
        if(DOWNLOAD_AUDIO_CODECS_DEPENDENCY)
            set(MikMod_LIBRARIES mikmod)
        else()
            find_library(MikMod_LIBRARIES NAMES mikmod
                         HINTS "${AUDIO_CODECS_INSTALL_PATH}/lib")
        endif()
        set(MikMod_FOUND 1)
        set(MikMod_INCLUDE_DIRS ${AUDIO_CODECS_PATH}/libmikmod/include)
    endif()

    if(MikMod_FOUND)
        message("== using MikMod ==")
        add_definitions(-DMUSIC_MOD_MIKMOD)
        if(NOT USE_SYSTEM_AUDIO_LIBRARIES OR NOT USE_MikMod_DYNAMIC)
            list(APPEND SDLMixerX_LINK_LIBS ${MikMod_LIBRARIES})
        endif()
        list(APPEND SDL_MIXER_INCLUDE_PATHS ${MikMod_INCLUDE_DIRS})
        list(APPEND SDLMixerX_SOURCES
            ${CMAKE_CURRENT_LIST_DIR}/music_mikmod.c)
    endif()
endif()
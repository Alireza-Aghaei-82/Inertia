cmake_minimum_required(VERSION 3.16)

project(Inertia VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

if(CMAKE_BUILD_TYPE STREQUAL RELEASE)
    set(CMAKE_CXX_FLAGS_RELEASE "-Ofast")
endif()

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Widgets)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appInertia main.cpp)

qt_add_qml_module(appInertia
                  URI Inertia
                  VERSION 1.0

                  QML_FILES
                  ui/Main.qml
                  ui/ClearCell.qml
                  ui/MinedCell.qml
                  ui/WallCell.qml
                  ui/StopCell.qml
                  ui/ExplodedCell.qml
                  ui/GemCell.qml
                  ui/Ball.qml
                  ui/HintArrow.qml

                  ui/js/mainOperations.js

                  RESOURCES
                  images.qrc

                  SOURCES
                  games-data-path.hpp
                  games-data-path.cpp)


set_target_properties(appInertia PROPERTIES
                      MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
                      MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
                      MACOSX_BUNDLE TRUE
                      WIN32_EXECUTABLE TRUE)

target_link_libraries(appInertia PRIVATE Qt6::Quick Qt6::Widgets)

include(GNUInstallDirs)

install(TARGETS appInertia
        BUNDLE DESTINATION .
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_BINDIR}
)

qt_generate_deploy_qml_app_script(TARGET appInertia
                                  OUTPUT_SCRIPT deploy_script)

install(SCRIPT ${deploy_script})

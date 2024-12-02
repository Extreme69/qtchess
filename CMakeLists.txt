cmake_minimum_required(VERSION 3.16)

project(chess VERSION 0.1 LANGUAGES CXX)

# Enable automatic handling of Qt meta-object, resource, and translation files
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find the required Qt6 components
find_package(Qt6 6.2 REQUIRED COMPONENTS Quick)

# Add the executable target and resource file
qt_add_executable(appchess
    main.cpp
    resources.qrc
    ChessPiece.qml
    TurnDisplay.qml
    ChessboardLabels.qml
)


# Add QML module with resources
qt_add_qml_module(appchess
    URI chess
    VERSION 1.0
    QML_FILES Main.qml ChessPiece.qml TurnDisplay.qml ChessboardLabels.qml
    RESOURCES resources.qrc 
)

set(CMAKE_AUTORCC ON) # Add this line
# Set application properties
set_target_properties(appchess PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# Link the target to the Qt libraries
target_link_libraries(appchess
    PRIVATE Qt6::Quick
)

# Install the executable
include(GNUInstallDirs)
install(TARGETS appchess
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

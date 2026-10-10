# SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
# SPDX-License-Identifier: LGPL-2.0-or-later

qt_add_executable(bigscreen-ui-demo
    main.cpp
)

ecm_add_qml_module(bigscreen-ui-demo
    URI org.kde.bigscreen.ui.demo
    GENERATE_PLUGIN_SOURCE
    NO_IMPORT_SCAN
    DEPENDENCIES
        QtQuick
        org.kde.bigscreen.ui
        org.kde.kirigami
)

ecm_target_qml_sources(bigscreen-ui-demo SOURCES
    Main.qml
)

target_link_libraries(bigscreen-ui-demo PRIVATE
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
)

add_dependencies(bigscreen-ui-demo bigscreenuiplugin)

install(TARGETS bigscreen-ui-demo ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})

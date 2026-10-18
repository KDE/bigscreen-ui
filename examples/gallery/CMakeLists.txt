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

set_source_files_properties(Artwork.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

ecm_target_qml_sources(bigscreen-ui-demo SOURCES
    Artwork.qml
    ControlsPage.qml
    DetailsPage.qml
    ExpandingRail.qml
    GallerySection.qml
    GridPage.qml
    ListsPage.qml
    Main.qml
    MediaPage.qml
    OverlaysPage.qml
    PlaybackPage.qml
    PlayerPage.qml
)

target_link_libraries(bigscreen-ui-demo PRIVATE
    Qt6::Qml
    Qt6::Quick
    KF6::I18nQml
)

qt_add_resources(bigscreen-ui-demo images
    PREFIX /
    FILES
        images/altai.jpg
        images/coast.jpg
        images/flow.jpg
        images/honeywave.jpg
        images/konqi.png
        images/milkyway.jpg
        images/mountain.jpg
        images/patak.jpg
        images/safelanding.jpg
        images/scarlettree.jpg
        images/shell.jpg
        images/volna.jpg
)

add_dependencies(bigscreen-ui-demo bigscreenuiplugin)

install(TARGETS bigscreen-ui-demo ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})

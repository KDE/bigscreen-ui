# SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
# SPDX-License-Identifier: LGPL-2.0-or-later

ecm_add_qml_module(bigscreenuiplugin
    URI org.kde.bigscreen.ui
    VERSION 1.0
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES
        QtQuick
        org.kde.kirigami
)

set_source_files_properties(Units.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

target_sources(bigscreenuiplugin PRIVATE
    backhandler.cpp
    backhandler.h
)

ecm_target_qml_sources(bigscreenuiplugin SOURCES
    qml/Button.qml
    qml/ButtonDelegate.qml
    qml/ComboBoxDelegate.qml
    qml/DelegateBackground.qml
    qml/Dialog.qml
    qml/DialogButtonBox.qml
    qml/ItemDelegate.qml
    qml/PopupBackground.qml
    qml/ScrollablePage.qml
    qml/SidebarOverlay.qml
    qml/SidebarOverlayHeader.qml
    qml/SwitchDelegate.qml
    qml/TextDelegate.qml
    qml/TextField.qml
    qml/Units.qml
)

target_link_libraries(bigscreenuiplugin PRIVATE
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
)

ecm_finalize_qml_module(bigscreenuiplugin DESTINATION ${KDE_INSTALL_QMLDIR})

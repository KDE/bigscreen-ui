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

set_source_files_properties(qml/Units.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

target_sources(bigscreenuiplugin PRIVATE
    backhandler.cpp
    backhandler.h
    keynavigationgroup.cpp
    keynavigationgroup.h
)

ecm_target_qml_sources(bigscreenuiplugin SOURCES
    qml/ApplicationWindow.qml
    qml/BackdropImage.qml
    qml/Badge.qml
    qml/Button.qml
    qml/ButtonDelegate.qml
    qml/Chip.qml
    qml/ChipBar.qml
    qml/ComboBoxDelegate.qml
    qml/ContentRail.qml
    qml/ContextDrawer.qml
    qml/ContextDrawerHeader.qml
    qml/DelegateBackground.qml
    qml/Dialog.qml
    qml/DialogButtonBox.qml
    qml/EdgeFadeEffect.qml
    qml/HeroBanner.qml
    qml/ItemDelegate.qml
    qml/Label.qml
    qml/MediaCard.qml
    qml/MediaProgressBar.qml
    qml/NavigationBar.qml
    qml/NavigationTab.qml
    qml/PlayerOverlay.qml
    qml/PopupBackground.qml
    qml/RailView.qml
    qml/RoundButton.qml
    qml/ScrollablePage.qml
    qml/SeekBar.qml
    qml/Sidebar.qml
    qml/StackView.qml
    qml/SwitchDelegate.qml
    qml/SwitchIndicator.qml
    qml/TextDelegate.qml
    qml/TextField.qml
    qml/Toast.qml
    qml/Units.qml
)

target_link_libraries(bigscreenuiplugin PRIVATE
    Qt6::Qml
    Qt6::Quick
)

ecm_finalize_qml_module(bigscreenuiplugin DESTINATION ${KDE_INSTALL_QMLDIR})

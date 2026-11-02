// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Templates as T

import org.kde.kirigami as Kirigami
import org.kde.bigscreen.ui as BigscreenUI

BigscreenUI.ScrollablePage {
    id: root

    title: "Overlays"
    background: BigscreenUI.BackdropImage {
        source: "qrc:/images/milkyway.jpg"
    }

    ColumnLayout {
        spacing: Kirigami.Units.gridUnit * 3

        GallerySection {
            title: "Dialog"
            description: "A modal dialog with standard buttons."

            BigscreenUI.Button {
                id: dialogButton
                focus: true
                text: "Open dialog"
                KeyNavigation.down: contextDrawerButton
                icon.name: "window-new"
                onClicked: dialog.open()
            }
        }

        GallerySection {
            title: "Context drawer"
            description: "A panel that slides in from the right to display contextual options."

            BigscreenUI.Button {
                id: contextDrawerButton
                text: "Open context drawer"
                KeyNavigation.up: dialogButton
                KeyNavigation.down: pushButton
                icon.name: "sidebar-expand-right"
                onClicked: contextDrawer.open()
            }
        }

        GallerySection {
            title: "Stack view"

            BigscreenUI.Button {
                id: pushButton
                text: "Push a page"
                KeyNavigation.up: contextDrawerButton
                icon.name: "list-add"
                onClicked: T.ApplicationWindow.window.pushPage()
            }
        }
    }

    BigscreenUI.Dialog {
        id: dialog

        property Item returnFocusItem: null

        title: "Rename profile"
        standardButtons: T.Dialog.Ok | T.Dialog.Cancel
        openFocusItem: nameField

        onAboutToShow: returnFocusItem = root.Window.activeFocusItem
        onAboutToHide: returnFocusItem?.forceActiveFocus()
        onAccepted: console.log("Dialog accepted: “%1”".arg(nameField.text))
        onRejected: console.log("Dialog cancelled")

        contentItem: ColumnLayout {
            spacing: Kirigami.Units.gridUnit

            BigscreenUI.Label {
                Layout.fillWidth: true
                text: "This is a description."
                wrapMode: Text.Wrap
            }

            BigscreenUI.TextField {
                id: nameField
                Layout.fillWidth: true
                placeholderText: "Profile name"
                text: "Living room"
                Keys.onDownPressed: dialog.footer.forceActiveFocus()
            }
        }
    }

    BigscreenUI.ContextDrawer {
        id: contextDrawer

        property Item returnFocusItem: null

        onAboutToShow: returnFocusItem = root.Window.activeFocusItem
        onAboutToHide: returnFocusItem?.forceActiveFocus()

        header: BigscreenUI.ContextDrawerHeader {
            title: "Picture settings"
            subtitle: "Applies to everything you watch"
            iconSource: "video-display"
        }

        content: ColumnLayout {
            spacing: Kirigami.Units.smallSpacing

            BigscreenUI.SwitchDelegate {
                id: firstOption
                Layout.fillWidth: true
                text: "HDR when available"
                checked: true
                KeyNavigation.down: motionOption
                onToggled: console.log(checked ? "ContextDrawer: HDR on" : "ContextDrawer: HDR off")
            }
            BigscreenUI.SwitchDelegate {
                id: motionOption
                Layout.fillWidth: true
                text: "Motion smoothing"
                KeyNavigation.up: firstOption
                KeyNavigation.down: resetOption
                onToggled: console.log(checked ? "ContextDrawer: Motion smoothing on" : "ContextDrawer: Motion smoothing off")
            }
            BigscreenUI.ButtonDelegate {
                id: resetOption
                Layout.fillWidth: true
                text: "Reset picture settings"
                icon.name: "edit-undo"
                KeyNavigation.up: motionOption
                onClicked: {
                    contextDrawer.close();
                }
            }
            Item {
                Layout.fillHeight: true
            }
        }

        openFocusItem: firstOption
    }
}

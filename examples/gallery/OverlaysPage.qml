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
            description: "A modal dialog with standard buttons. The back key cancels it, and focus returns to the button that opened it."

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
            description: "A panel that slides in from the right, for options related to the current screen, such as subtitle or audio track selection."

            BigscreenUI.Button {
                id: contextDrawerButton
                text: "Open context drawer"
                KeyNavigation.up: dialogButton
                KeyNavigation.down: pushButton
                icon.name: "sidebar-show-right"
                onClicked: contextDrawer.open()
            }
        }

        GallerySection {
            title: "Stack view"
            description: "StackView crossfades between pages. The pushed page uses BackHandler, so Escape or the remote's back key returns here."

            BigscreenUI.Button {
                id: pushButton
                text: "Push a page"
                KeyNavigation.up: contextDrawerButton
                icon.name: "go-next"
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
                text: "Profiles keep separate watch history and recommendations."
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
                    console.log("ContextDrawer: Reset");
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

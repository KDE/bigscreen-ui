// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.bigscreen.ui as BigscreenUI

BigscreenUI.ApplicationWindow {
    id: root

    width: 1600
    height: 900
    minimumWidth: 1280
    minimumHeight: 720
    visible: true
    title: "Bigscreen UI Gallery"

    function pushPage(): void {
        stack.push(pushedPage);
    }

    BigscreenUI.StackView {
        id: stack
        anchors.fill: parent
        focus: true

        initialItem: FocusScope {
            // Pages leave up and left unhandled at their edges, so they reach the
            // navigation bar and the sidebar
            Keys.onUpPressed: navigationBar.forceActiveFocus()
            Keys.onLeftPressed: sidebar.forceActiveFocus()

            BigscreenUI.BackHandler.enabled: visible
            BigscreenUI.BackHandler.onActivated: navigationBar.forceActiveFocus()

            StackLayout {
                id: pages

                anchors.fill: parent
                // Pages fill the window behind the navigation bar and sidebar, and keep
                // their content clear of them
                SafeArea.additionalMargins.top: navigationBar.height
                SafeArea.additionalMargins.left: sidebar.collapsedWidth
                currentIndex: navigationBar.currentIndex

                ControlsPage {}
                ListsPage {}
                MediaPage {}
                PlaybackPage {}
                OverlaysPage {}
            }

            BigscreenUI.NavigationBar {
                id: navigationBar

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                SafeArea.additionalMargins.left: sidebar.collapsedWidth
                focus: true

                Keys.onDownPressed: pages.children[pages.currentIndex].forceActiveFocus()
                onActivated: index => sidebar.currentIndex = index

                actions: [
                    Kirigami.Action {
                        text: "Controls"
                    },
                    Kirigami.Action {
                        text: "Lists"
                    },
                    Kirigami.Action {
                        text: "Media"
                    },
                    Kirigami.Action {
                        text: "Playback"
                    },
                    Kirigami.Action {
                        text: "Overlays"
                    }
                ]
            }

            // The same pages again, out of the way until the user moves left
            BigscreenUI.Sidebar {
                id: sidebar

                mode: pin.checked ? BigscreenUI.Sidebar.Expanded
                    : showRail.checked ? BigscreenUI.Sidebar.Rail
                    : BigscreenUI.Sidebar.Hidden
                height: parent.height
                title: "Bigscreen UI"
                iconName: "applications-graphics"

                KeyNavigation.right: pages.children[pages.currentIndex]
                onActivated: index => {
                    navigationBar.currentIndex = index;
                    pages.children[index].forceActiveFocus();
                }

                actions: [
                    Kirigami.Action {
                        text: "Controls"
                        icon.name: "configure"
                    },
                    Kirigami.Action {
                        text: "Lists"
                        icon.name: "view-list-details"
                    },
                    Kirigami.Action {
                        text: "Media"
                        icon.name: "folder-videos"
                    },
                    Kirigami.Action {
                        text: "Playback"
                        icon.name: "media-playback-start"
                    },
                    Kirigami.Action {
                        text: "Overlays"
                        icon.name: "window-new"
                    },
                    Kirigami.Action {
                        separator: true
                    },
                    Kirigami.Action {
                        id: showRail
                        text: "Show rail"
                        icon.name: "sidebar-collapse-left"
                        checkable: true
                    },
                    Kirigami.Action {
                        id: pin
                        text: "Pin sidebar"
                        icon.name: "pin"
                        checkable: true
                    }
                ]
            }
        }
    }

    Component {
        id: pushedPage

        BigscreenUI.ScrollablePage {
            title: "A pushed page"

            BigscreenUI.BackHandler.enabled: visible
            BigscreenUI.BackHandler.onActivated: stack.pop()

            ColumnLayout {
                spacing: Kirigami.Units.gridUnit * 2

                BigscreenUI.Label {
                    Layout.fillWidth: true
                    text: "This page was pushed onto a StackView. It is a ScrollablePage, which keeps the focused item in view as you move through it."
                    wrapMode: Text.Wrap
                }

                BigscreenUI.Button {
                    focus: true
                    text: "Go back"
                    icon.name: "go-previous"
                    onClicked: stack.pop()
                }
            }
        }
    }
}

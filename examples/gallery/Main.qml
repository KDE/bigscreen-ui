// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T

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

    readonly property list<T.Action> pageActions: [
        Kirigami.Action {
            text: "Controls"
            icon.name: "configure"
            onTriggered: root.showPage(controlsPage)
        },
        Kirigami.Action {
            text: "Lists"
            icon.name: "view-list-details"
            onTriggered: root.showPage(listsPage)
        },
        Kirigami.Action {
            text: "Media"
            icon.name: "folder-videos"
            onTriggered: root.showPage(mediaPage)
        },
        Kirigami.Action {
            text: "Grid"
            icon.name: "view-list-icons"
            onTriggered: root.showPage(gridPage)
        },
        Kirigami.Action {
            text: "Playback"
            icon.name: "media-playback-start"
            onTriggered: root.showPage(playbackPage)
        },
        Kirigami.Action {
            text: "Overlays"
            icon.name: "window-new"
            onTriggered: root.showPage(overlaysPage)
        }
    ]

    readonly property list<Item> pages: [
        ControlsPage {
            id: controlsPage
        },
        ListsPage {
            id: listsPage
        },
        MediaPage {
            id: mediaPage
        },
        GridPage {
            id: gridPage
        },
        PlaybackPage {
            id: playbackPage
        },
        OverlaysPage {
            id: overlaysPage
        }
    ]

    function pushPage(): void {
        pageStack.push(pushedPage);
    }

    initialPage: controlsPage

    navigationBar: BigscreenUI.NavigationBar {
        actions: root.pageActions
        onActivated: index => sidebar.currentIndex = index
    }

    sidebar: BigscreenUI.Sidebar {
        id: sidebar

        mode: pin.checked ? BigscreenUI.Sidebar.Expanded
            : showRail.checked ? BigscreenUI.Sidebar.Rail
            : BigscreenUI.Sidebar.Hidden
        title: "Bigscreen UI"
        iconName: "applications-graphics"

        onActivated: index => root.navigationBar.currentIndex = index

        actions: [...root.pageActions, separator, showRail, pin]

        Kirigami.Action {
            id: separator
            separator: true
        }
        Kirigami.Action {
            id: showRail
            text: "Show rail"
            icon.name: "sidebar-collapse-left"
            checkable: true
        }
        Kirigami.Action {
            id: pin
            text: "Pin sidebar"
            icon.name: "pin"
            checkable: true
        }
    }

    Component {
        id: pushedPage

        BigscreenUI.ScrollablePage {
            title: "A pushed page"

            BigscreenUI.BackHandler.enabled: visible
            BigscreenUI.BackHandler.onActivated: root.pageStack.pop()

            ColumnLayout {
                spacing: Kirigami.Units.gridUnit * 2

                BigscreenUI.Label {
                    Layout.fillWidth: true
                    text: "This page was pushed onto the window's page stack. It is a ScrollablePage, which keeps the focused item in view as you move through it."
                    wrapMode: Text.Wrap
                }

                BigscreenUI.Button {
                    focus: true
                    text: "Go back"
                    icon.name: "go-previous"
                    onClicked: root.pageStack.pop()
                }
            }
        }
    }
}

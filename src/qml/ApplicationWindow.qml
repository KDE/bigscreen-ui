// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Templates as T

import org.kde.kirigami as Kirigami

/*!
   \brief A top-level window with a stack of pages, and an optional navigation bar and sidebar.

   \code
   BigscreenUI.ApplicationWindow {
       id: root

       readonly property var pageActions: [
           Kirigami.Action { text: "Home"; onTriggered: root.showPage(homePage) },
           Kirigami.Action { text: "Settings"; onTriggered: root.showPage(settingsPage) }
       ]

       readonly property var pages: [
           HomePage { id: homePage },
           SettingsPage { id: settingsPage }
       ]

       initialPage: homePage
       navigationBar: BigscreenUI.NavigationBar {
           actions: root.pageActions
       }
   }
   \endcode
 */
T.ApplicationWindow {
    id: root

    /*!
       \brief The stack of pages. Push onto it to open a page over the whole window.
     */
    readonly property alias pageStack: stack

    /*!
       \brief The page shown first.
     */
    property alias initialPage: stack.initialItem

    /*!
       \brief A NavigationBar, shown across the top of the window.
     */
    property Item navigationBar

    /*!
       \brief A Sidebar, shown along the left of the window.
     */
    property Item sidebar

    /*!
       \brief Shows \a page in place of the current page, closing any pages pushed over it.
     */
    function showPage(page: var): void {
        const fromSidebar = sidebar ? sidebar.activeFocus : false;
        if (stack.currentItem !== page) {
            stack.replace(null, page);
        }
        // The sidebar covers the page while it has focus, so move on to the page
        if (fromSidebar && stack.currentItem) {
            stack.currentItem.forceActiveFocus();
        }
    }

    Kirigami.Theme.colorSet: Kirigami.Theme.Window
    Kirigami.Theme.inherit: false

    color: Kirigami.Theme.backgroundColor

    StackView {
        id: stack

        readonly property bool atTop: depth <= 1

        anchors.fill: parent
        focus: true

        SafeArea.additionalMargins.top: navbarHolder.visible ? navbarHolder.height : 0
        SafeArea.additionalMargins.left: sidebarHolder.visible ? sidebarHolder.collapsedWidth : 0

        // The navigation bar and sidebar hide under pages pushed over the top, so the page
        // takes focus from them
        onAtTopChanged: {
            if (!atTop) {
                forceActiveFocus();
            }
        }

        Keys.onUpPressed: event => {
            event.accepted = navbarHolder.visible;
            if (event.accepted) {
                root.navigationBar.forceActiveFocus();
            }
        }
        Keys.onLeftPressed: event => {
            event.accepted = sidebarHolder.visible;
            if (event.accepted) {
                root.sidebar.forceActiveFocus();
            }
        }

        // Back from a page goes to the navigation bar, or the sidebar if there is none
        BackHandler.enabled: navbarHolder.visible || sidebarHolder.visible
        BackHandler.onActivated: (navbarHolder.visible ? root.navigationBar : root.sidebar).forceActiveFocus()
    }

    FocusScope {
        id: navbarHolder

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: root.navigationBar ? root.navigationBar.height : 0
        visible: root.navigationBar && stack.atTop
        children: root.navigationBar ? [root.navigationBar] : []

        SafeArea.additionalMargins.left: sidebarHolder.visible ? sidebarHolder.collapsedWidth : 0

        // Down that the navigation bar leaves unhandled
        Keys.onDownPressed: stack.currentItem?.forceActiveFocus()

        // Back from the navigation bar goes on to the sidebar
        BackHandler.enabled: sidebarHolder.visible
        BackHandler.onActivated: root.sidebar.forceActiveFocus()

        Binding {
            target: root.navigationBar
            property: "width"
            value: navbarHolder.width
        }
    }

    FocusScope {
        id: sidebarHolder

        // The width the sidebar takes up beside the pages
        readonly property real collapsedWidth: root.sidebar?.collapsedWidth ?? root.sidebar?.width ?? 0

        width: root.sidebar ? root.sidebar.width : 0
        height: parent.height
        visible: root.sidebar && stack.atTop
        children: root.sidebar ? [root.sidebar] : []

        // Right that the sidebar leaves unhandled
        Keys.onRightPressed: stack.currentItem?.forceActiveFocus()

        Binding {
            target: root.sidebar
            property: "height"
            value: sidebarHolder.height
        }
    }
}

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

       readonly property list<Kirigami.Action> pageActions: [
           Kirigami.Action { text: "Home"; onTriggered: root.showPage(homePage) },
           Kirigami.Action { text: "Settings"; onTriggered: root.showPage(settingsPage) }
       ]

       readonly property list<BigscreenUI.Page> pages: [
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
    property var initialPage

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
        if (stack.currentItem !== page) {
            // HACK: Parent the page before the stack takes it
            // Otherwise, if the page has already read its SafeArea, its children's SafeArea margins never update
            if (page instanceof Item) {
                page.parent = stack;
            }
            stack.replace(null, page);
        }

        // Focus the page to close the sidebar if it's open
        const fromSidebar = sidebar ? sidebar.activeFocus : false;
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
        anchors.leftMargin: sidebarHolder.reservedWidth
        focus: true

        initialItem: {
            // HACK: Parent the page before the stack takes it
            // Otherwise, if the page has already read its SafeArea, its children's SafeArea margins never update
            if (root.initialPage instanceof Item) {
                root.initialPage.parent = stack;
            }
            return root.initialPage;
        }

        SafeArea.additionalMargins.top: navbarHolder.visible ? navbarHolder.height : 0
        SafeArea.additionalMargins.left: sidebarHolder.overlapWidth

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
        anchors.leftMargin: sidebarHolder.reservedWidth
        height: root.navigationBar ? root.navigationBar.height : 0
        visible: root.navigationBar && stack.atTop
        children: root.navigationBar ? [root.navigationBar] : []

        SafeArea.additionalMargins.left: sidebarHolder.overlapWidth

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

        // The width the sidebar takes up while focus is elsewhere
        readonly property real collapsedWidth: visible ? root.sidebar.collapsedWidth ?? root.sidebar.width : 0

        // Amount of space fully reserved for the sidebar
        property real reservedWidth: visible && root.sidebar.mode === Sidebar.Expanded ? collapsedWidth : 0
        Behavior on reservedWidth {
            NumberAnimation {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.OutCubic
            }
        }

        // Amount of space reserved for the sidebar, but is overlaid over the page (contents use SafeArea to get overlaid dimensions)
        readonly property real overlapWidth: Math.max(0, collapsedWidth - reservedWidth)

        // Fills the window, so the sidebar can dim the pages while it is expanded over them
        anchors.fill: parent
        visible: root.sidebar && stack.atTop
        children: root.sidebar ? [root.sidebar] : []

        Keys.onRightPressed: stack.currentItem?.forceActiveFocus()

        Binding {
            target: root.sidebar
            property: "height"
            value: sidebarHolder.height
        }
    }
}

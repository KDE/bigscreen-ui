// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T

import org.kde.kirigami as Kirigami

/*!
   \brief A sidebar for switching between the sections of an app.

   \code
   BigscreenUI.Sidebar {
       id: sidebar
       height: parent.height
       KeyNavigation.right: pages.children[pages.currentIndex]
       onActivated: pages.children[pages.currentIndex].forceActiveFocus()

       actions: [
           Kirigami.Action { text: "Home"; icon.name: "go-home" },
           Kirigami.Action { text: "Movies"; icon.name: "folder-videos" },
           Kirigami.Action { separator: true },
           Kirigami.Action { text: "Settings"; icon.name: "configure" }
       ]
   }

   StackLayout {
       id: pages
       anchors.fill: parent
       anchors.leftMargin: sidebar.collapsedWidth
       currentIndex: sidebar.currentIndex
       ...
   }
   \endcode
 */
FocusScope {
    id: root

    enum Mode {
        Rail,     // Collapses to a rail of icons
        Expanded, // Always fully shown
        Hidden    // Hides completely until it has focus
    }

    /*!
       \brief How the sidebar looks while focus is elsewhere.
       \default Sidebar.Rail
     */
    property int mode: Sidebar.Rail

    /*!
       \brief The entries of the sidebar.
     */
    property list<T.Action> actions

    /*!
       \brief The index of the current sidebar entry.
     */
    property int currentIndex: 0

    /*!
       \brief The app name shown at the top of the sidebar.
     */
    property string title

    /*!
       \brief The icon shown at the top of the sidebar, next to the title.
     */
    property string iconName

    /*!
       \brief The footer of the sidebar.
     */
    property Item footer

    /*!
       \brief The width of the sidebar when it shows its labels.
     */
    property real expandedWidth: Kirigami.Units.gridUnit * 16

    /*!
       \brief Whether the sidebar shows its labels.
     */
    readonly property bool expanded: mode === Sidebar.Expanded || activeFocus

    /*!
       \brief Whether the sidebar is expanded over the pages, rather than beside them
     */
    readonly property bool overlaying: expanded && mode !== Sidebar.Expanded

    /*!
       \brief The width the sidebar takes up while focus is elsewhere.
     */
    readonly property real collapsedWidth: mode === Sidebar.Expanded ? expandedWidth : mode === Sidebar.Hidden ? 0 : railWidth

    readonly property bool hasSeparator: {
        for (const action of actions) {
            if (("separator" in action) && action.separator) {
                return true;
            }
        }
        return false;
    }

    readonly property real railWidth: Kirigami.Units.iconSizes.medium + (padding + Units.horizontalPadding) * 2
    readonly property real padding: Kirigami.Units.largeSpacing

    signal activated(int index)

    /*!
       \brief This signal is emitted when the sidebar wants to close (e.g. user taps in empty space). Move focus to the page, so the sidebar collapses.
     */
    signal dismissRequested()

    width: (expanded || mode === Sidebar.Hidden) ? expandedWidth : collapsedWidth
    Behavior on width { NumberAnimation { duration: Kirigami.Units.longDuration; easing.type: Easing.OutCubic } }

    transform: Translate {
        x: root.mode === Sidebar.Hidden && !root.expanded ? -root.width : 0
        Behavior on x { NumberAnimation { duration: Kirigami.Units.longDuration; easing.type: Easing.OutCubic } }
    }

    Kirigami.Theme.colorSet: Kirigami.Theme.Window
    Kirigami.Theme.inherit: false

    onActiveFocusChanged: {
        if (activeFocus) {
            // Focus always arrives on the current entry
            (entries.itemAt(currentIndex) ?? entryView.column.children.find(entry => entry.activeFocusOnTab && entry.enabled))?.forceActiveFocus();
        }
    }

    SidebarScrim {
        z: -1
        width: root.parent ? root.parent.width : 0
        height: root.height
        sidebarWidth: root.width
        overlaying: root.overlaying
        onClicked: root.dismissRequested()
    }

    // Open full view when sidebar is tapped in rail mode
    MouseArea {
        anchors.fill: parent
        enabled: root.mode === Sidebar.Rail
        onClicked: {
            if (!root.overlaying) {
                root.forceActiveFocus();
            }
        }
    }

    SidebarBackground {
        anchors.fill: parent
        expanded: root.expanded
        pinned: root.mode === Sidebar.Expanded
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: Kirigami.Units.smallSpacing

        SidebarHeader {
            Layout.fillWidth: true
            Layout.leftMargin: root.padding + Units.horizontalPadding
            Layout.rightMargin: root.padding
            Layout.topMargin: Kirigami.Units.gridUnit * 2
            Layout.bottomMargin: Kirigami.Units.gridUnit * 2
            title: root.title
            iconName: root.iconName
            expanded: root.expanded
        }

        SidebarEntryView {
            id: entryView
            Layout.fillWidth: true
            Layout.fillHeight: true

            Repeater {
                id: entries
                model: root.actions

                delegate: SidebarEntry {
                    id: entry

                    required property int index

                    Layout.fillWidth: true
                    Layout.fillHeight: separator
                    Layout.leftMargin: root.padding
                    Layout.rightMargin: root.padding

                    current: index === root.currentIndex
                    expanded: root.expanded

                    onActiveFocusChanged: if (activeFocus) entryView.ensureVisible(entry)
                    onClicked: {
                        if (toggle) {
                            modelData.trigger();
                            return;
                        }
                        root.currentIndex = index;
                        modelData.trigger();
                        root.activated(index);
                    }
                }
            }

            Item {
                Layout.fillHeight: !root.hasSeparator
            }

            Item {
                id: footerHolder
                Layout.fillWidth: true
                Layout.leftMargin: root.padding
                Layout.rightMargin: root.padding
                Layout.topMargin: Kirigami.Units.smallSpacing
                implicitHeight: root.footer?.visible ? root.footer.implicitHeight : 0
                visible: root.footer !== null
                data: root.footer ? [root.footer] : []

                onChildrenChanged: {
                    for (const child of children) {
                        child.anchors.left = footerHolder.left;
                        child.anchors.right = footerHolder.right;
                        child.anchors.bottom = footerHolder.bottom;
                    }
                }
            }

            Item {
                implicitHeight: Kirigami.Units.gridUnit
            }
        }
    }
}

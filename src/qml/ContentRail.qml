// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

/*!
   \brief A titled, horizontally scrolling row of items, usually MediaCards.

   The current item stays at the left edge while the row scrolls.

   \code
   BigscreenUI.ContentRail {
       title: i18n("Recently added")
       model: recentlyAddedModel
       delegate: BigscreenUI.MediaCard {
           required property var modelData
           text: modelData.title
           source: modelData.poster
       }
   }
   \endcode
 */
FocusScope {
    id: root

    /*!
       \brief The title shown above the row.
     */
    property string title

    /*!
       \brief The space between the left screen edge and the first item.
       \default Units.contentMargin(SafeArea.margins.left)
     */
    property real leftPadding: Units.contentMargin(SafeArea.margins.left)

    /*!
       \brief The space between the last item and the right screen edge.
       \default Units.contentMargin(SafeArea.margins.right)
     */
    property real rightPadding: Units.contentMargin(SafeArea.margins.right)

    property alias model: listView.model
    property alias delegate: listView.delegate
    property alias currentIndex: listView.currentIndex
    property alias currentItem: listView.currentItem
    property alias count: listView.count
    property alias spacing: listView.spacing

    /*!
       \qmlproperty ListView view
       \brief The ListView showing the items.
     */
    property alias view: listView

    implicitHeight: column.implicitHeight
    implicitWidth: column.implicitWidth

    Behavior on opacity {
        NumberAnimation {
            duration: Kirigami.Units.shortDuration
            easing.type: Easing.OutQuad
        }
    }

    ColumnLayout {
        id: column
        anchors.fill: parent
        spacing: Kirigami.Units.largeSpacing * 2

        Label {
            Layout.fillWidth: true
            Layout.leftMargin: root.leftPadding
            Layout.rightMargin: root.rightPadding
            visible: text.length > 0
            text: root.title
            elide: Text.ElideRight
            type: Label.Section
            Accessible.role: Accessible.Heading
        }

        ListView {
            id: listView

            Layout.fillWidth: true
            Layout.fillHeight: true
            implicitHeight: currentItem ? currentItem.implicitHeight : 0

            focus: true
            orientation: ListView.Horizontal
            spacing: Kirigami.Units.gridUnit
            keyNavigationEnabled: true
            boundsBehavior: Flickable.StopAtBounds
            clip: false

            leftMargin: root.leftPadding
            rightMargin: root.rightPadding
            displayMarginBeginning: root.leftPadding
            displayMarginEnd: root.rightPadding

            highlightFollowsCurrentItem: false

            // Keep the current item at the left padding until the end of the row is reached
            onCurrentItemChanged: scrollToCurrent()
            onWidthChanged: scrollToCurrent()

            function scrollToCurrent(): void {
                if (!currentItem) {
                    return;
                }
                const minimum = originX - leftMargin;
                const maximum = Math.max(minimum, originX + contentWidth + rightMargin - width);
                scrollAnimation.to = Math.max(minimum, Math.min(maximum, currentItem.x - root.leftPadding));
                scrollAnimation.restart();
            }

            NumberAnimation {
                id: scrollAnimation
                target: listView
                property: "contentX"
                duration: Kirigami.Units.longDuration
                easing.type: Easing.OutCubic
            }
        }
    }
}

// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Window
import QtQuick.Templates as T

import org.kde.kirigami as Kirigami

/*!
   \brief A page that can scroll. The selected item is kept in the visible view.

   Give the page a single content item, such as a ColumnLayout.

   The page can sit under a header such as a NavigationBar, so its background reaches the
   top of the screen. Set \c SafeArea.additionalMargins.top on the page to the header's height,
   so content starts below the header and never scrolls under it.

   \code
   BigscreenUI.ScrollablePage {
       title: i18n("Settings")

       ColumnLayout {
           ...
       }
   }
   \endcode
 */
T.Page {
    id: root

    /*!
       \brief The content of the page.
     */
    default property alias content: flickable.flickableData

    /*!
       \qmlproperty Flickable flickable
       \brief The Flickable that scrolls the content.
     */
    property alias flickable: flickable

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding,
                            implicitHeaderWidth,
                            implicitFooterWidth)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding
                             + (implicitHeaderHeight > 0 ? implicitHeaderHeight + spacing : 0)
                             + (implicitFooterHeight > 0 ? implicitFooterHeight + spacing : 0))

    // Keep content inside the safe area, for example below a header overlaying the page.
    // When overriding a padding, add the safe area margin for that side.
    padding: Kirigami.Units.gridUnit * 2
    topPadding: padding + SafeArea.margins.top
    bottomPadding: padding + SafeArea.margins.bottom
    // The title-safe margin, so content isn't lost at the edges of a TV
    leftPadding: Units.contentMargin(SafeArea.margins.left)
    rightPadding: Units.contentMargin(SafeArea.margins.right)

    header: Label {
        visible: text.length > 0
        text: root.title
        leftPadding: root.leftPadding
        rightPadding: root.rightPadding
        topPadding: root.topPadding
        type: Label.Title
        elide: Text.ElideRight
        Accessible.role: Accessible.Heading
    }

    /*!
       \brief Scrolls so that \a item is fully visible, with some margin around it.
     */
    function ensureVisible(item: Item): void {
        const position = item.mapToItem(flickable.contentItem, 0, 0);
        const margin = Kirigami.Units.gridUnit;
        // The part of the viewport inside the padding
        const top = flickable.contentY + flickable.topMargin;
        const bottom = flickable.contentY + flickable.height - flickable.bottomMargin;
        let target = flickable.contentY;
        if (position.y - margin < top) {
            target = position.y - margin - flickable.topMargin;
        } else if (position.y + item.height + margin > bottom) {
            target = position.y + item.height + margin + flickable.bottomMargin - flickable.height;
        }
        scrollTo(target);
    }

    /*!
       \brief Scrolls back to the start of the content.
     */
    function scrollToTop(): void {
        scrollTo(-flickable.topMargin);
    }

    function scrollTo(contentY: real): void {
        const minimum = -flickable.topMargin;
        const maximum = Math.max(minimum, flickable.contentHeight + flickable.bottomMargin - flickable.height);
        scrollAnimation.to = Math.max(minimum, Math.min(maximum, contentY));
        scrollAnimation.restart();
    }

    contentItem: Item {
        Flickable {
            id: flickable

            readonly property real topOverflow: Math.max(0, root.topPadding - root.SafeArea.margins.top)
            readonly property real bottomOverflow: Math.max(0, root.bottomPadding - root.SafeArea.margins.bottom)

            x: -root.leftPadding
            y: -topOverflow
            width: parent.width + root.leftPadding + root.rightPadding
            height: parent.height + topOverflow + bottomOverflow

            leftMargin: root.leftPadding
            rightMargin: root.rightPadding
            topMargin: topOverflow
            bottomMargin: bottomOverflow

            clip: true
            layer.enabled: contentHeight > height - topMargin - bottomMargin
            layer.effect: EdgeFadeEffect {
                topFadeLength: flickable.topOverflow
                bottomFadeLength: flickable.bottomOverflow
            }
            contentWidth: parent.width
            contentHeight: contentItem.childrenRect.height
            boundsBehavior: Flickable.StopAtBounds

            Component.onCompleted: {
                contentY = -topMargin;
                updateContentWidth();
            }

            function updateContentWidth(): void {
                for (const child of contentItem.children) {
                    child.width = Qt.binding(() => root.availableWidth);
                }
            }

            Connections {
                target: flickable.contentItem
                function onChildrenChanged() {
                    flickable.updateContentWidth();
                }
            }

            NumberAnimation {
                id: scrollAnimation
                target: flickable
                property: "contentY"
                duration: Kirigami.Units.longDuration
                easing.type: Easing.OutCubic
            }
        }
    }

    Connections {
        target: root.Window.window
        function onActiveFocusItemChanged() {
            const item = root.Window.activeFocusItem;
            for (let parent = item; parent; parent = parent.parent) {
                if (parent === flickable.contentItem) {
                    root.ensureVisible(item);
                    return;
                }
            }
        }
    }
}

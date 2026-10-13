// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick as QQ

import org.kde.kirigami as Kirigami

/*!
   \brief A vertically scrolling grid, accomodating for a page's content margins.
   The current item is always kept fully in view, with room around it for its focus effect.

   For a grid of MediaCards, use MediaGrid.

   \endcode
 */
QQ.GridView {
    id: root

    /*!
       \brief The horizontal space between items, at the end of each cell.
     */
    property real columnSpacing: 0

    /*!
       \brief The vertical space between rows of items, at the bottom of each cell.
     */
    property real rowSpacing: 0

    // Room around the edges for the focused item to grow into
    readonly property real __focusRoom: Kirigami.Units.gridUnit * 2

    leftMargin: Units.horizontalContentMargin(SafeArea.margins.left)
    rightMargin: Units.horizontalContentMargin(SafeArea.margins.right) - columnSpacing // aesthetic choice
    topMargin: __focusRoom + SafeArea.margins.top
    bottomMargin: __focusRoom + SafeArea.margins.bottom

    focus: true
    keyNavigationEnabled: true
    boundsBehavior: Flickable.StopAtBounds
    clip: true
    cacheBuffer: Math.max(height, 0)
    highlightFollowsCurrentItem: false

    layer.enabled: contentHeight > height - topMargin - bottomMargin
    layer.effect: EdgeFadeEffect {
        topFadeLength: root.contentY > -root.topMargin ? root.__focusRoom : 0
        bottomFadeLength: root.__focusRoom
    }

    onWidthChanged: __ensureCurrent()
    onActiveFocusChanged: __ensureCurrent()

    function __ensureCurrent(): void {
        if (currentIndex < 0 && count > 0 && width > 0) {
            currentIndex = 0;
        }
    }

    onCurrentItemChanged: scrollToCurrent()
    onHeightChanged: scrollToCurrentInstant()
    onCellHeightChanged: scrollToCurrentInstant()

    /*!
       \brief Scrolls so the current item is fully in view.
     */
    function scrollToCurrent(): void {
        if (!__canScroll()) {
            return;
        }
        scrollAnimation.to = __currentTargetContentY();
        scrollAnimation.restart();
    }

    function scrollToCurrentInstant(): void {
        if (!__canScroll()) {
            return;
        }
        // A scroll still animating would otherwise carry on to where it was headed
        scrollAnimation.stop();
        contentY = __currentTargetContentY();
    }

    // Whether the item can be scrolled to
    function __canScroll(): bool {
        return currentItem !== null && width > 0 && height > 0;
    }

    function __currentTargetContentY(): double {
        if (!currentItem) {
            return 0;
        }
        const top = contentY + topMargin;
        const bottom = contentY + height - bottomMargin;
        let target = contentY;
        if (currentItem.y < top) {
            target = currentItem.y - topMargin;
        } else if (currentItem.y + cellHeight - rowSpacing > bottom) {
            target = currentItem.y + cellHeight - rowSpacing + bottomMargin - height;
        }
        const minimum = originY - topMargin;
        const maximum = Math.max(minimum, originY + contentHeight + bottomMargin - height);
        return Math.max(minimum, Math.min(maximum, target));
    }

    NumberAnimation {
        id: scrollAnimation
        target: root
        property: "contentY"
        duration: Kirigami.Units.longDuration
        easing.type: Easing.OutCubic
    }
}

// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick

import org.kde.kirigami as Kirigami

/*!
   \brief A vertically scrolling grid of MediaCards, such as the contents of a folder or a
   library.

   The grid fits as many columns as it can, with cards at least \l minimumCardWidth wide,
   and stretches them to fill the width. Bind each card's \c artworkWidth and
   \c artworkHeight to \l cardWidth and \l artworkHeight.

   \code
   BigscreenUI.MediaGrid {
       anchors.fill: parent
       model: videosModel
       delegate: BigscreenUI.MediaCard {
           required property string title
           required property url thumbnail
           artworkWidth: GridView.view.cardWidth
           artworkHeight: GridView.view.artworkHeight
           text: title
           source: thumbnail
       }
   }
   \endcode
 */
GridView {
    id: root

    /*!
       \brief The smallest width of a card; cards grow from it to fill the row.
     */
    property real minimumCardWidth: Kirigami.Units.gridUnit * 16

    /*!
       \brief The width divided by the height of the artwork.
       \default 16 / 9
     */
    property real artworkAspectRatio: 16 / 9

    /*!
       \brief The horizontal space between cards.
     */
    property real columnSpacing: Kirigami.Units.gridUnit * 1.5

    /*!
       \brief The vertical space between rows of cards.
     */
    property real rowSpacing: Kirigami.Units.gridUnit * 2

    /*!
       \brief The height reserved under the artwork for the card's title and subtitle.
     */
    property real labelHeight: titleMetrics.height + subtitleMetrics.height + Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing * 2

    /*!
       \brief The number of columns of cards.
     */
    readonly property int columns: Math.max(1, Math.floor((width - leftMargin - rightMargin) / (minimumCardWidth + columnSpacing)))

    /*!
       \brief The width of each card's artwork.
     */
    readonly property real cardWidth: Math.floor(cellWidth - columnSpacing)

    /*!
       \brief The height of each card's artwork.
     */
    readonly property real artworkHeight: Math.round(cardWidth / artworkAspectRatio)

    // Room around the edges for the focused card to grow into
    readonly property real __focusRoom: Kirigami.Units.gridUnit * 2

    leftMargin: Units.horizontalContentMargin(SafeArea.margins.left)
    rightMargin: Units.horizontalContentMargin(SafeArea.margins.right) - columnSpacing
    topMargin: __focusRoom + SafeArea.margins.top
    bottomMargin: __focusRoom + SafeArea.margins.bottom

    cellWidth: (width - leftMargin - rightMargin) / columns
    cellHeight: artworkHeight + labelHeight + rowSpacing

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
       \brief Scrolls so the current card is fully in view.
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

    FontMetrics {
        id: titleMetrics
        font.pixelSize: Units.defaultFontPixelSize
    }

    FontMetrics {
        id: subtitleMetrics
        font.pixelSize: Units.smallFontPixelSize
    }
}

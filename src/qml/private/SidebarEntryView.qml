// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

// Sidebar scroll view
Flickable {
    id: root

    default property alias columnData: column.data
    readonly property alias column: column

    readonly property bool overflowing: column.implicitHeight > height
    readonly property real fadeLength: overflowing ? Kirigami.Units.gridUnit : 0

    // Scrolls so that the item is fully visible
    function ensureVisible(item: Item) {
        if (!overflowing) {
            return;
        }
        const y = item.mapToItem(contentItem, 0, 0).y;
        const top = contentY + topMargin;
        const bottom = contentY + height - bottomMargin;
        let target = contentY;
        if (y < top) {
            target = y - topMargin;
        } else if (y + item.height > bottom) {
            target = y + item.height + bottomMargin - height;
        }
        scrollAnimation.to = Math.max(-topMargin, Math.min(contentHeight + bottomMargin - height, target));
        scrollAnimation.restart();
    }

    contentWidth: width
    contentHeight: Math.max(height - topMargin - bottomMargin, column.implicitHeight)
    topMargin: fadeLength
    bottomMargin: fadeLength
    interactive: overflowing
    boundsBehavior: Flickable.StopAtBounds
    clip: overflowing
    layer.enabled: overflowing
    layer.effect: EdgeFadeEffect {
        topFadeLength: root.fadeLength
        bottomFadeLength: root.fadeLength
    }

    NumberAnimation {
        id: scrollAnimation
        target: root
        property: "contentY"
        duration: Kirigami.Units.longDuration
        easing.type: Easing.OutCubic
    }

    ColumnLayout {
        id: column
        width: root.width
        height: root.contentHeight
        spacing: Kirigami.Units.smallSpacing

        KeyNavigationGroup.orientation: Qt.Vertical
    }
}

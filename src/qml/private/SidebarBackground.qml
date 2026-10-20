// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick

import org.kde.kirigami as Kirigami

Item {
    id: root

    // Whether the sidebar shows its labels
    property bool expanded

    // Whether the sidebar is always fully shown
    property bool pinned

    Rectangle {
        id: minimizedBackground
        anchors.fill: parent
        opacity: root.expanded ? 0 : 1
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0; color: Qt.alpha(Kirigami.Theme.backgroundColor, 0.85) }
            GradientStop { position: 1; color: "transparent" }
        }
        Behavior on opacity {
            OpacityAnimator { duration: Kirigami.Units.longDuration }
        }
    }

    Rectangle {
        id: expandedBackground
        anchors.fill: parent
        color: root.pinned ? Kirigami.ColorUtils.tintWithAlpha(Kirigami.Theme.backgroundColor, "black", 0.18)
                           : Kirigami.Theme.backgroundColor
        opacity: root.expanded ? 1 : 0
        Behavior on opacity {
            OpacityAnimator { duration: Kirigami.Units.longDuration }
        }
    }

    Rectangle {
        id: rightShadow
        anchors.right: parent.right
        width: Kirigami.Units.largeSpacing * 2
        height: parent.height
        opacity: root.pinned ? 0.2 : 0
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0; color: "transparent" }
            GradientStop { position: 1; color: "black" }
        }
    }
}

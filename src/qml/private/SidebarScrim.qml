// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick

import org.kde.kirigami as Kirigami

// Overlay over app content when sidebar is open
Item {
    id: root

    property real sidebarWidth
    property bool overlaying

    signal clicked()

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: root.overlaying ? 0.45 : 0
        Behavior on opacity {
            OpacityAnimator {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.OutCubic
            }
        }
    }

    Rectangle {
        x: root.sidebarWidth
        width: Kirigami.Units.largeSpacing * 3
        height: parent.height
        opacity: root.overlaying ? 0.3 : 0
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0; color: "black" }
            GradientStop { position: 1; color: "transparent" }
        }
        Behavior on opacity {
            OpacityAnimator { duration: Kirigami.Units.longDuration }
        }
    }

    MouseArea {
        anchors.fill: parent
        anchors.leftMargin: root.sidebarWidth
        enabled: root.overlaying
        onClicked: root.clicked()
    }
}

// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick

import org.kde.kirigami as Kirigami

/*!
   \brief The track and handle of a switch, drawn in the Breeze style.
 */
Item {
    id: root

    /*!
       \brief Whether the switch is on.
     */
    property bool checked: false

    implicitWidth: Math.round(Kirigami.Units.gridUnit * 2.6)
    implicitHeight: handle.height

    opacity: enabled ? 1 : 0.5

    Rectangle {
        id: track
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: Math.round(Kirigami.Units.gridUnit * 1.2)
        radius: height / 2
        color: root.checked ? Kirigami.Theme.highlightColor : Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.15)

        Behavior on color {
            ColorAnimation {
                duration: Kirigami.Units.shortDuration
            }
        }
    }

    Rectangle {
        id: handle
        x: root.checked ? root.width - width : 0
        anchors.verticalCenter: parent.verticalCenter
        width: track.height + 4
        height: width
        radius: width / 2
        color: Kirigami.Theme.backgroundColor
        border.width: 1
        border.color: root.checked ? Kirigami.Theme.highlightColor : Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.35)

        Behavior on x {
            NumberAnimation {
                duration: Kirigami.Units.shortDuration
                easing.type: Easing.InOutCubic
            }
        }
    }
}

// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Templates as T

import org.kde.kirigami as Kirigami

/*!
   \brief A playback position slider. Left and right skip back and forward by \c stepSize.

   The track thickens and a handle appears while it has focus.
 */
T.Slider {
    id: root

    implicitWidth: Kirigami.Units.gridUnit * 20
    implicitHeight: Kirigami.Units.gridUnit * 2

    focusPolicy: Qt.StrongFocus
    hoverEnabled: true

    background: Rectangle {
        x: root.leftPadding
        y: root.topPadding + (root.availableHeight - height) / 2
        width: root.availableWidth
        height: root.activeFocus ? 10 : 6
        radius: height / 2
        color: Qt.alpha(Kirigami.Theme.textColor, 0.25)

        Behavior on height {
            NumberAnimation {
                duration: Kirigami.Units.shortDuration
            }
        }

        Rectangle {
            width: root.visualPosition * parent.width
            height: parent.height
            radius: height / 2
            color: Kirigami.Theme.highlightColor
        }
    }

    handle: Rectangle {
        x: root.leftPadding + root.visualPosition * root.availableWidth - width / 2
        y: root.topPadding + (root.availableHeight - height) / 2
        width: Kirigami.Units.gridUnit * 1.5
        height: width
        radius: width / 2
        color: Kirigami.Theme.backgroundColor
        border.width: 2
        border.color: Kirigami.Theme.highlightColor
        scale: (root.activeFocus || root.pressed) ? 1 : 0

        Behavior on scale {
            NumberAnimation {
                duration: Kirigami.Units.shortDuration
                easing.type: Easing.OutCubic
            }
        }
    }
}

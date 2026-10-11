// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Templates as T

import org.kde.kirigami as Kirigami

/*!
   \brief A thin progress bar for showing how far into a piece of media the user is.
 */
T.ProgressBar {
    id: root

    implicitWidth: Kirigami.Units.gridUnit * 10
    implicitHeight: 6

    background: Rectangle {
        radius: height / 2
        color: Qt.rgba(0, 0, 0, 0.6)
    }

    contentItem: Item {
        Rectangle {
            width: root.visualPosition * parent.width
            height: parent.height
            radius: height / 2
            color: Kirigami.Theme.highlightColor
        }
    }
}

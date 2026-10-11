// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.bigscreen.ui as BigscreenUI

// A titled group of components on a gallery page
ColumnLayout {
    id: root

    property string title
    property string description

    default property alias content: body.data

    Layout.fillWidth: true
    spacing: Kirigami.Units.largeSpacing

    BigscreenUI.Label {
        Layout.fillWidth: true
        text: root.title
        type: BigscreenUI.Label.Section
        Accessible.role: Accessible.Heading
    }

    BigscreenUI.Label {
        Layout.fillWidth: true
        Layout.maximumWidth: Kirigami.Units.gridUnit * 50
        visible: text.length > 0
        text: root.description
        color: Kirigami.Theme.disabledTextColor
        wrapMode: Text.Wrap
    }

    ColumnLayout {
        id: body
        Layout.fillWidth: true
        Layout.topMargin: Kirigami.Units.largeSpacing
        spacing: Kirigami.Units.gridUnit
    }
}

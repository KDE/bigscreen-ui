// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

RowLayout {
    id: root

    property string title
    property string iconName

    property bool expanded

    visible: title.length > 0 || iconName.length > 0
    spacing: Kirigami.Units.largeSpacing * 2

    Kirigami.Icon {
        implicitWidth: Kirigami.Units.iconSizes.medium
        implicitHeight: Kirigami.Units.iconSizes.medium
        source: root.iconName
        visible: root.iconName.length > 0
    }
    Label {
        Layout.fillWidth: true
        text: root.title
        type: Label.Heading
        font.weight: Font.Light
        elide: Text.ElideRight
        opacity: root.expanded ? 1 : 0
        Behavior on opacity {
            OpacityAnimator { duration: Kirigami.Units.shortDuration }
        }
    }
}

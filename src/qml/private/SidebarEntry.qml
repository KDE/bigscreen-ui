// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick

import org.kde.kirigami as Kirigami

ButtonDelegate {
    id: root

    required property Kirigami.Action modelData

    property bool current
    property bool expanded

    readonly property bool separator: modelData.separator
    readonly property bool toggle: modelData.checkable
    readonly property color foregroundColor: checked || activeFocus ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor

    implicitHeight: separator ? 0 : Kirigami.Units.gridUnit * 3
    verticalPadding: 0

    opacity: separator ? 0 : 1
    visible: modelData.visible
    enabled: !separator && modelData.enabled
    focusPolicy: separator ? Qt.NoFocus : Qt.TabFocus

    leftInset: 0
    rightInset: 0
    topInset: 0
    bottomInset: 0

    text: modelData.text
    icon.name: modelData.icon.name || modelData.icon.source
    icon.color: foregroundColor
    textItem.color: foregroundColor
    textItem.opacity: expanded ? 1 : 0
    Behavior on textItem.opacity {
        NumberAnimation { duration: Kirigami.Units.shortDuration }
    }

    checked: !toggle && current
    raisedBackground: checked

    trailingPadding: toggle ? Kirigami.Units.gridUnit : 0
    trailing: SwitchIndicator {
        visible: root.toggle
        implicitWidth: root.toggle ? implicitHeight * 2 : 0
        checked: root.modelData.checked
        highlighted: root.activeFocus || root.hovered
        enabled: root.enabled
        opacity: root.expanded ? 1 : 0
        Behavior on opacity {
            NumberAnimation { duration: Kirigami.Units.shortDuration }
        }
    }

    Accessible.role: toggle ? Accessible.CheckBox : Accessible.PageTab
    Accessible.checkable: toggle
    Accessible.checked: toggle && modelData.checked

    Keys.onEnterPressed: click()
}

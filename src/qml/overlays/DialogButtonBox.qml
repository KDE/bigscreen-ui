// SPDX-FileCopyrightText: 2025 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QtQuick.Effects

import org.kde.kirigami as Kirigami

T.DialogButtonBox {
    id: root

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    required property var dialog

    visible: count > 0

    topPadding: Kirigami.Units.gridUnit
    bottomPadding: Kirigami.Units.gridUnit
    leftPadding: Kirigami.Units.gridUnit
    rightPadding: Kirigami.Units.gridUnit
    alignment: Qt.AlignRight

    spacing: Kirigami.Units.mediumSpacing
    position: T.DialogButtonBox.Footer

    standardButtons: root.dialog.standardButtons

    onActiveFocusChanged: {
        if (activeFocus) {
            listView.currentIndex = 0;
            listView.forceActiveFocus();
        }
    }

    delegate: Button {
        icon.name: {
            switch (T.DialogButtonBox.buttonRole) {
            case T.DialogButtonBox.AcceptRole:
            case T.DialogButtonBox.YesRole:
                return "dialog-ok";
            case T.DialogButtonBox.RejectRole:
            case T.DialogButtonBox.NoRole:
                return "dialog-cancel";
            case T.DialogButtonBox.ApplyRole:
                return "dialog-ok-apply";
            case T.DialogButtonBox.ResetRole:
                return "edit-undo";
            case T.DialogButtonBox.DestructiveRole:
                return "edit-delete";
            case T.DialogButtonBox.HelpRole:
                return "help-contents";
            default:
                return "";
            }
        }

        // HACK: for some reason the height isn't correct on initial start
        onImplicitHeightChanged: height = implicitHeight

        onActiveFocusChanged: {
            if (activeFocus) {
                listView.forceActiveFocus()
            }
        }
        Kirigami.MnemonicData.controlType: Kirigami.MnemonicData.DialogButton
    }

    contentItem: ListView {
        id: listView
        keyNavigationEnabled: true
        implicitWidth: contentWidth
        implicitHeight: buttonMetrics.implicitHeight

        model: root.contentModel
        spacing: root.spacing
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds
        snapMode: ListView.SnapToItem

        Button {
            id: buttonMetrics
            visible: false
            text: 'A'
            icon.name: 'dialog-ok'
        }

        Keys.onLeftPressed: {
            if (currentIndex > 0) {
                currentIndex = Math.max(0, currentIndex - 1);
            }
        }

        Keys.onRightPressed: {
            if (currentIndex < count - 1) {
                currentIndex = Math.min(count - 1, currentIndex + 1);
            }
        }
    }
}

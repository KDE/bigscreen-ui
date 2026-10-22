// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Templates as T

import org.kde.kirigami as Kirigami

// A dialog showing a long text, such as a license, that the arrow keys scroll through
Dialog {
    id: root

    property string text

    standardButtons: T.Dialog.Close
    openFocusItem: textView

    contentItem: Flickable {
        id: textView

        readonly property real scrollVelocity: Math.sqrt(flickDeceleration * height)

        implicitHeight: Math.min(contentHeight, root.parent ? root.parent.height * 0.6 : Kirigami.Units.gridUnit * 20)
        contentWidth: width
        contentHeight: label.implicitHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        activeFocusOnTab: true

        Keys.onUpPressed: event => {
            event.accepted = !atYBeginning;
            if (event.accepted) {
                flick(0, scrollVelocity);
            }
        }
        Keys.onDownPressed: atYEnd ? root.footer.forceActiveFocus(Qt.TabFocusReason) : flick(0, -scrollVelocity)

        Label {
            id: label
            width: textView.width
            text: root.text
            wrapMode: Text.Wrap
            textFormat: Text.PlainText
        }
    }
}

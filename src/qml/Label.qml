// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Templates as T

import org.kde.kirigami as Kirigami

T.Label {
    color: Kirigami.Theme.textColor
    linkColor: Kirigami.Theme.linkColor
    font.pixelSize: Units.defaultFontPixelSize
    verticalAlignment: Text.AlignVCenter
}

// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Templates as T

import org.kde.kirigami as Kirigami

/*!
   \brief Text in the theme's text color, at a size readable from across the room.
 */
T.Label {
    color: Kirigami.Theme.textColor
    linkColor: Kirigami.Theme.linkColor
    font.pixelSize: Units.defaultFontPixelSize
    verticalAlignment: Text.AlignVCenter
}

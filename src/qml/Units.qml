// SPDX-FileCopyrightText: 2025 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma Singleton

import QtQml
import org.kde.kirigami as Kirigami

QtObject {
    readonly property int horizontalPadding: Kirigami.Units.gridUnit
    readonly property int verticalPadding: Kirigami.Units.gridUnit

    readonly property int verticalSpacing: Kirigami.Units.gridUnit
    readonly property int horizontalSpacing: Kirigami.Units.largeSpacing

    readonly property int smallFontPixelSize: 14
    readonly property int defaultFontPixelSize: 18
    readonly property int headingFontPixelSize: 22
    readonly property int sectionFontPixelSize: 30
    readonly property int titleFontPixelSize: 48
    readonly property int displayFontPixelSize: 72

    // Recommended margins between the edges of the screen and content
    readonly property int horizontalScreenMargin: Kirigami.Units.gridUnit * 5
    readonly property int verticalScreenMargin: Kirigami.Units.gridUnit * 3

    // Margins between a screen edge and content: recommended padding + safearea (navigation bars)
    function horizontalContentMargin(safeMargin: real): real {
        return Math.max(horizontalScreenMargin, safeMargin + Kirigami.Units.gridUnit * 2);
    }
    function verticalContentMargin(safeMargin: real): real {
        return Math.max(verticalScreenMargin, safeMargin + Kirigami.Units.gridUnit * 2);
    }

    // Corner radius of media artwork
    readonly property int cardCornerRadius: Kirigami.Units.cornerRadius * 2

    // Border width of the highlight drawn around focused media artwork
    readonly property int focusBorderWidth: 4

    // Scale applied to focused media artwork
    readonly property real focusScale: 1.06
}

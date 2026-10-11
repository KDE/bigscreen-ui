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

    // Margin between the screen edges and content
    readonly property int screenMargin: Kirigami.Units.gridUnit * 5

    // Margin between an edge and content, given the SafeArea margin on that side: the
    // screen margin, or more to keep clear of something over that edge, such as a Sidebar.
    function contentMargin(safeMargin: real): real {
        return Math.max(screenMargin, safeMargin + Kirigami.Units.gridUnit * 2);
    }

    // Corner radius of media artwork
    readonly property int cardCornerRadius: Kirigami.Units.cornerRadius * 2

    // Border width of the highlight drawn around focused media artwork
    readonly property int focusBorderWidth: 4

    // Scale applied to focused media artwork
    readonly property real focusScale: 1.06
}

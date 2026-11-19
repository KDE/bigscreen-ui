// SPDX-FileCopyrightText: 2025 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma Singleton

import QtQml
import org.kde.kirigami as Kirigami

/*!
   \qmltype Units
   \inqmlmodule org.kde.bigscreen.ui

   \brief Standard units for use across apps to ensure a unified design.
 */
QtObject {

    /*!
       \brief Standard horizontal padding.
     */
    readonly property int horizontalPadding: Kirigami.Units.gridUnit

    /*!
       \brief Standard vertical padding.
     */
    readonly property int verticalPadding: Kirigami.Units.gridUnit


    /*!
       \brief Standard vertical spacing.
     */
    readonly property int verticalSpacing: Kirigami.Units.gridUnit

    /*!
       \brief Standard horizontal spacing.
     */
    readonly property int horizontalSpacing: Kirigami.Units.largeSpacing


    /*!
       \brief Standard size for small text.
     */
    readonly property int smallFontPixelSize: 14

    /*!
       \brief Standard size for regular text.
     */
    readonly property int defaultFontPixelSize: 18

    /*!
       \brief Standard size for small headings.
     */
    readonly property int headingFontPixelSize: 22

    /*!
       \brief Standard size for section headings.
     */
    readonly property int sectionFontPixelSize: 30

    /*!
       \brief Standard size for titles.
     */
    readonly property int titleFontPixelSize: 48

    /*!
       \brief Standard size for display text.
     */
    readonly property int displayFontPixelSize: 72


    /*!
       \brief Recommended maximum margin between the horizontal edges of the screen and content.
     */
    readonly property int horizontalScreenMargin: Kirigami.Units.gridUnit * 5

    /*!
       \brief Recommended maximum margin between the vertical edges of the screen and content.
     */
    readonly property int verticalScreenMargin: Kirigami.Units.gridUnit * 3

    // Actual recommended margins (factors in screen size)
    function horizontalScreenMarginFor(windowWidth: real): int {
        return Math.round(Math.max(Kirigami.Units.gridUnit, Math.min(horizontalScreenMargin, windowWidth * 0.05)));
    }
    function verticalScreenMarginFor(windowHeight: real): int {
        return Math.round(Math.max(Kirigami.Units.gridUnit, Math.min(verticalScreenMargin, windowHeight * 0.05)));
    }

    // The least space between content and whatever is beside it
    readonly property int __minimumContentSpacing: Kirigami.Units.gridUnit * 2

    /*!
       \brief Corner radius of cards.
     */
    readonly property int cardCornerRadius: Kirigami.Units.cornerRadius * 2

    /*!
       \brief Border width of the highlight drawn around focused media artwork.
     */
    readonly property int focusBorderWidth: 4

    /*!
       \brief Scale applied to focused media artwork.
     */
    readonly property real focusScale: 1.07
}

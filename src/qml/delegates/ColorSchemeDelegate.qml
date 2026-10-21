// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick

/*!
   \brief A delegate for picking the app's color scheme.
 */
ComboBoxDelegate {
    text: i18nd("bigscreen-ui", "Color scheme")
    icon.name: "preferences-desktop-color"

    model: ColorSchemeManager.model
    textRole: "display"
    currentIndex: ColorSchemeManager.currentIndex
    onActivated: index => ColorSchemeManager.currentIndex = index
}

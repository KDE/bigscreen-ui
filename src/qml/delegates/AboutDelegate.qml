// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Templates as T

import org.kde.kirigami as Kirigami
import org.kde.coreaddons as Core

/*!
   \brief A delegate that opens the app's AboutPage, for a settings page or menu.

   It shows the app's name, version and icon, and pushes the AboutPage onto the window's page
   stack when activated.

   \code
   BigscreenUI.AboutDelegate {}
   \endcode
 */
ButtonDelegate {
    id: root

    /*!
       \brief The information to show, with the same shape as KAboutData.
       \default the app's KAboutData
     */
    property var aboutData: Core.AboutData

    text: i18nd("bigscreen-ui", "About %1", aboutData.displayName)
    description: i18nd("bigscreen-ui", "Version %1", aboutData.version)
    icon.name: Kirigami.Settings.applicationWindowIcon.name || aboutData.componentName

    trailing: Kirigami.Icon {
        source: "go-next"
        implicitWidth: Kirigami.Units.iconSizes.small
        implicitHeight: Kirigami.Units.iconSizes.small
    }

    onClicked: T.ApplicationWindow.window.pageStack.push(aboutPage, { aboutData: root.aboutData })

    Component {
        id: aboutPage
        AboutPage {}
    }
}

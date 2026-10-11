// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Templates as T

import org.kde.kirigami as Kirigami

/*!
   \brief A page of an app.

   The content fills the whole page, so it can reach the edges of the screen, such as a row
   of media that scrolls off the side. Keep text and controls clear of anything overlaying the
   page, such as a NavigationBar, with \c SafeArea.margins. For a page of controls with the
   standard margins, use ScrollablePage.

   When \l title is set, it is shown at the top of the page.

   \code
   BigscreenUI.Page {
       background: BigscreenUI.BackdropImage {
           source: "backdrop.jpg"
       }

       BigscreenUI.HeroBanner {
           x: BigscreenUI.Units.contentMargin(parent.SafeArea.margins.left)
           ...
       }
   }
   \endcode
 */
T.Page {
    id: root

    header: Label {
        visible: text.length > 0
        text: root.title
        leftPadding: Units.contentMargin(root.SafeArea.margins.left)
        rightPadding: Units.contentMargin(root.SafeArea.margins.right)
        topPadding: Kirigami.Units.gridUnit * 2 + root.SafeArea.margins.top
        type: Label.Title
        elide: Text.ElideRight
        Accessible.role: Accessible.Heading
    }
}

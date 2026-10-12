// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Templates as T

import org.kde.kirigami as Kirigami

/*!
   \brief A page of an app.

   The content fills the whole page, so it can reach the edges of the screen, such as a row
   of media that scrolls off the side. Keep text and controls within \l contentMargins, clear
   of the edges of the screen and anything overlaying the page, such as a NavigationBar. For a
   page of controls with the standard margins, use ScrollablePage.

   When \l title is set, it is shown at the top of the page.

   \code
   BigscreenUI.Page {
       background: BigscreenUI.BackdropImage {
           source: "backdrop.jpg"
       }

       BigscreenUI.HeroBanner {
           x: parent.contentMargins.left
           y: parent.contentMargins.top
           ...
       }
   }
   \endcode
 */
T.Page {
    id: root

    /*!
       \qmlproperty real Page::contentMargins.left
       \qmlproperty real Page::contentMargins.right
       \qmlproperty real Page::contentMargins.top
       \qmlproperty real Page::contentMargins.bottom
       \brief How far text and controls should keep from each edge of the page.

       This includes SafeArea margins, that could be set by NavigationBar or Sidebar in an ApplicationWindow.
     */
    readonly property Margins contentMargins: Margins {
        left: Units.horizontalContentMargin(root.SafeArea.margins.left)
        right: Units.horizontalContentMargin(root.SafeArea.margins.right)
        top: Units.verticalContentMargin(root.SafeArea.margins.top)
        bottom: Units.verticalContentMargin(root.SafeArea.margins.bottom)
    }

    component Margins: QtObject {
        property real left
        property real right
        property real top
        property real bottom
    }

    readonly property bool __underNavigation: T.StackView.index === 0
    SafeArea.additionalMargins.top: __underNavigation ? T.ApplicationWindow.window?.__pageTopMargin ?? 0 : 0
    SafeArea.additionalMargins.left: __underNavigation ? T.ApplicationWindow.window?.__pageLeftMargin ?? 0 : 0

    header: Label {
        visible: text.length > 0
        text: root.title
        leftPadding: root.contentMargins.left
        rightPadding: root.contentMargins.right
        topPadding: root.contentMargins.top
        type: Label.Title
        elide: Text.ElideRight
        Accessible.role: Accessible.Heading
    }
}

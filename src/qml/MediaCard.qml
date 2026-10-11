// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Templates as T

import org.kde.kirigami as Kirigami

/*!
   \brief A focusable piece of media artwork.

   The artwork is drawn at \l artworkWidth by \l artworkHeight. The title (\c text) and
   \l subtitle are shown underneath it when set. When focused, the artwork grows slightly
   and gets a highlight border.

   When used as the delegate of a ListView or GridView, focusing the card with the mouse
   also makes it the view's current item.
 */
T.ItemDelegate {
    id: root

    /*!
       \brief The source of the artwork image.
     */
    property alias source: artwork.source

    /*!
       \brief Secondary text shown under the title.
     */
    property string subtitle

    /*!
       \brief How far into the media the user is, from 0 to 1. A progress bar is shown
       over the artwork when this is greater than 0 and less than 1.
       \default -1
     */
    property real progress: -1

    /*!
       \brief Whether to mark the media as watched.
     */
    property bool watched: false

    /*!
       \brief The width of the artwork.
     */
    property real artworkWidth: Kirigami.Units.gridUnit * 12

    /*!
       \brief The height of the artwork. Defaults to a 2:3 poster ratio.
     */
    property real artworkHeight: artworkWidth * 1.5

    /*!
       \qmlproperty ShadowedImage artworkItem
       \brief The item that draws the artwork.
     */
    property alias artworkItem: artwork

    readonly property bool hasLabels: text.length > 0 || subtitle.length > 0

    implicitWidth: artworkWidth
    implicitHeight: artworkHeight + (hasLabels ? labels.implicitHeight + Kirigami.Units.largeSpacing : 0)

    padding: 0
    focusPolicy: Qt.StrongFocus
    hoverEnabled: true

    Accessible.name: subtitle.length > 0 ? text + ", " + subtitle : text

    onPressed: root.forceActiveFocus()
    Keys.onReturnPressed: click()
    Keys.onEnterPressed: click()

    onActiveFocusChanged: {
        if (!activeFocus) {
            return;
        }
        // Keep the view's current item in sync when focus arrives by mouse or touch
        const view = ListView.view ?? GridView.view;
        if (view) {
            const index = view.indexAt(x + width / 2, y + height / 2);
            if (index >= 0) {
                view.currentIndex = index;
            }
        }
    }

    background: null

    contentItem: Item {
        Kirigami.ShadowedImage {
            id: artwork

            width: root.artworkWidth
            height: root.artworkHeight

            radius: Units.cardCornerRadius
            color: Kirigami.Theme.alternateBackgroundColor
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            sourceSize.width: width * Screen.devicePixelRatio
            sourceSize.height: height * Screen.devicePixelRatio

            border.width: root.activeFocus ? Units.focusBorderWidth : 0
            border.color: Kirigami.Theme.highlightColor

            shadow.size: root.activeFocus ? Kirigami.Units.gridUnit * 1.5 : Kirigami.Units.largeSpacing
            shadow.yOffset: root.activeFocus ? Kirigami.Units.smallSpacing * 2 : Kirigami.Units.smallSpacing
            shadow.color: Qt.rgba(0, 0, 0, 0.5)

            scale: root.activeFocus ? Units.focusScale : 1.0
            Behavior on scale {
                NumberAnimation {
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.OutCubic
                }
            }

            MediaProgressBar {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
                visible: root.progress > 0 && root.progress < 1
                value: root.progress
            }

            Rectangle {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: Kirigami.Units.largeSpacing
                visible: root.watched
                width: Kirigami.Units.iconSizes.medium
                height: width
                radius: width / 2
                color: Kirigami.Theme.highlightColor

                Kirigami.Icon {
                    anchors.centerIn: parent
                    width: Kirigami.Units.iconSizes.small
                    height: width
                    source: "checkmark"
                    color: Kirigami.Theme.highlightedTextColor
                    isMask: true
                }
            }
        }

        ColumnLayout {
            id: labels

            y: artwork.height + Kirigami.Units.largeSpacing + (root.activeFocus ? Kirigami.Units.smallSpacing * 2 : 0)
            width: artwork.width
            spacing: 0
            visible: root.hasLabels

            Behavior on y {
                NumberAnimation {
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.OutCubic
                }
            }

            Label {
                Layout.fillWidth: true
                text: root.text
                visible: text.length > 0
                elide: Text.ElideRight
                Accessible.ignored: true
            }
            Label {
                Layout.fillWidth: true
                text: root.subtitle
                visible: text.length > 0
                elide: Text.ElideRight
                color: Kirigami.Theme.disabledTextColor
                type: Label.Small
                Accessible.ignored: true
            }
        }
    }
}

// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick

import org.kde.kirigami as Kirigami

/*!
   \brief Full-screen artwork that fades into the window background on the left and at the
   bottom, so text drawn over it stays readable.

   Changing \l source fades to the new image once it has loaded.
 */
Item {
    id: root

    /*!
       \brief The image to show.
     */
    property url source

    /*!
       \brief The color the artwork fades into.
       \default Kirigami.Theme.backgroundColor
     */
    property color fadeColor: Kirigami.Theme.backgroundColor

    /*!
       \brief The opacity of the artwork itself.
     */
    property real artworkOpacity: 0.85

    property Image __front: imageA
    property Image __back: imageB

    onSourceChanged: {
        if (__front.source.toString() === source.toString()) {
            return;
        }
        __back.source = source;
        if (__back.status === Image.Ready || source.toString() === "") {
            __swap();
        }
    }

    function __swap(): void {
        const previous = __front;
        __front = __back;
        __back = previous;
        __front.opacity = root.artworkOpacity;
        __back.opacity = 0;
    }

    Image {
        id: imageA
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        opacity: 0
        Behavior on opacity {
            NumberAnimation {
                duration: Kirigami.Units.veryLongDuration
            }
        }
        onStatusChanged: if (status === Image.Ready && root.__back === imageA && source.toString() === root.source.toString()) root.__swap()
    }

    Image {
        id: imageB
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        opacity: 0
        Behavior on opacity {
            NumberAnimation {
                duration: Kirigami.Units.veryLongDuration
            }
        }
        onStatusChanged: if (status === Image.Ready && root.__back === imageB && source.toString() === root.source.toString()) root.__swap()
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: root.fadeColor }
            GradientStop { position: 0.24; color: Qt.alpha(root.fadeColor, 0.94) }
            GradientStop { position: 0.6; color: Qt.alpha(root.fadeColor, 0.45) }
            GradientStop { position: 1.0; color: Qt.alpha(root.fadeColor, 0.15) }
        }
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.alpha(root.fadeColor, 0.8) }
            GradientStop { position: 0.2; color: Qt.alpha(root.fadeColor, 0) }
            GradientStop { position: 0.34; color: Qt.alpha(root.fadeColor, 0) }
            GradientStop { position: 0.6; color: Qt.alpha(root.fadeColor, 0.7) }
            GradientStop { position: 0.94; color: root.fadeColor }
        }
    }
}

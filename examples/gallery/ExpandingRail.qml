// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.bigscreen.ui as BigscreenUI

FocusScope {
    id: root

    property alias title: rail.title
    property alias model: rail.model

    readonly property Item currentItem: rail.currentItem
    readonly property var movie: rail.currentItem?.modelData

    property bool expanded: false

    signal moreInfoRequested(var movie)

    implicitHeight: column.implicitHeight

    onActiveFocusChanged: {
        if (!activeFocus) {
            expanded = false;
        }
    }

    BigscreenUI.BackHandler.enabled: expanded
    BigscreenUI.BackHandler.onActivated: {
        expanded = false;
        rail.forceActiveFocus();
    }

    ColumnLayout {
        id: column

        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 0

        BigscreenUI.ContentRail {
            id: rail

            Layout.fillWidth: true
            focus: true
            KeyNavigation.down: root.expanded ? playButton : null

            delegate: BigscreenUI.MediaCard {
                required property var modelData

                artworkWidth: Kirigami.Units.gridUnit * 12
                source: modelData.image
                text: modelData.title

                onClicked: {
                    root.expanded = true;
                    playButton.forceActiveFocus();
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: root.expanded ? hero.implicitHeight + Kirigami.Units.gridUnit * 2 : 0
            clip: true

            Behavior on Layout.preferredHeight {
                NumberAnimation {
                    duration: Kirigami.Units.veryLongDuration
                    easing.type: Easing.OutCubic
                }
            }

            BigscreenUI.HeroBanner {
                id: hero

                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: rail.leftPadding
                anchors.topMargin: Kirigami.Units.gridUnit
                width: Math.round(parent.width * 0.5)
                KeyNavigation.up: rail

                title: root.movie?.title ?? ""
                titlePixelSize: BigscreenUI.Units.titleFontPixelSize
                metadata: root.movie ? [String(root.movie.year), root.movie.runtime, root.movie.genres] : []
                badges: root.movie?.badges ?? []
                description: root.movie?.synopsis ?? ""

                BigscreenUI.Button {
                    id: playButton
                    text: "Play"
                    icon.name: "media-playback-start"
                    onClicked: console.log("Inline details: Play %1".arg(root.movie.title))
                }
                BigscreenUI.Button {
                    text: "More info"
                    icon.name: "documentinfo"
                    onClicked: root.moreInfoRequested(root.movie)
                }
            }
        }
    }
}

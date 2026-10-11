// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick

import org.kde.kirigami as Kirigami
import org.kde.bigscreen.ui as BigscreenUI

// PlayerOverlay over a still image, with simulated playback
BigscreenUI.Page {
    id: root

    readonly property var movie: Artwork.movies[3]
    property real position: 38 * 60 * 1000
    readonly property real duration: 107 * 60 * 1000
    property bool playing: true

    background: Rectangle {
        color: "black"

        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            source: root.movie.image
            opacity: root.playing ? 1 : 0.6
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: root.visible && root.playing
        onTriggered: root.position = Math.min(root.duration, root.position + 1000)
    }

    BigscreenUI.PlayerOverlay {
        id: overlay

        anchors.fill: parent
        focus: true

        overline: "PlayerOverlay"
        title: root.movie.title
        position: root.position
        duration: root.duration
        playing: root.playing

        onPlayPauseRequested: {
            root.playing = !root.playing;
            console.log(root.playing ? "PlayerOverlay: Play" : "PlayerOverlay: Pause");
        }
        onSeekRequested: position => root.position = position

        actions: [
            Kirigami.Action {
                text: "Subtitles"
                icon.name: "media-view-subtitles-symbolic"
                onTriggered: console.log("PlayerOverlay action: Subtitles")
            },
            Kirigami.Action {
                text: "Audio"
                icon.name: "audio-volume-high"
                onTriggered: console.log("PlayerOverlay action: Audio")
            }
        ]
    }
}

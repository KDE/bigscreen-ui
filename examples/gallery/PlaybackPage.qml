// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick

import org.kde.kirigami as Kirigami
import org.kde.bigscreen.ui as BigscreenUI

// PlayerOverlay over a still image, with simulated playback
BigscreenUI.Page {
    id: root

    property int movieIndex: 3
    readonly property var movie: Artwork.movies[movieIndex]
    property real position: 38 * 60 * 1000
    readonly property real duration: 107 * 60 * 1000
    property bool playing: true
    property bool buffering: false

    function play(index: int): void {
        movieIndex = index;
        position = 0;
        buffering = true;
        bufferingTimer.restart();
    }

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
        running: root.visible && root.playing && !root.buffering
        onTriggered: root.position = Math.min(root.duration, root.position + 1000)
    }

    // Simulates loading after seeking or switching movie
    Timer {
        id: bufferingTimer
        interval: 1500
        onTriggered: root.buffering = false
    }

    BigscreenUI.PlayerOverlay {
        id: overlay

        anchors.fill: parent
        focus: true

        overline: "PlayerOverlay"
        title: root.movie.title
        metadata: [String(root.movie.year), root.movie.genres]
        position: root.position
        duration: root.duration
        playing: root.playing
        busy: root.buffering
        hasPrevious: root.movieIndex > 0
        hasNext: root.movieIndex < Artwork.movies.length - 1

        onPreviousRequested: root.play(root.movieIndex - 1)
        onNextRequested: root.play(root.movieIndex + 1)

        onPlayPauseRequested: {
            root.playing = !root.playing;
            console.log(root.playing ? "PlayerOverlay: Play" : "PlayerOverlay: Pause");
        }
        onSeekRequested: position => {
            root.position = position;
            root.buffering = true;
            bufferingTimer.restart();
        }

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

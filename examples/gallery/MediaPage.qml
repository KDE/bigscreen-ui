// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.bigscreen.ui as BigscreenUI

BigscreenUI.Page {
    id: root

    property var shownItem: Artwork.movies[0]
    property string shownRail: "Featured"
    readonly property bool browsing: rails.activeFocus

    function show(item: var, rail: string): void {
        pending = { item: item, rail: rail };
        showTimer.restart();
    }

    property var pending

    background: BigscreenUI.BackdropImage {
        source: root.shownItem.image
    }

    onBrowsingChanged: {
        if (!browsing) {
            show(Artwork.movies[0], "Featured");
        }
    }

    Timer {
        id: showTimer
        interval: 150
        onTriggered: {
            root.shownItem = root.pending.item;
            root.shownRail = root.pending.rail;
        }
    }

    BigscreenUI.HeroBanner {
        id: hero

        x: root.contentMargins.left
        y: root.contentMargins.top
        width: Math.round(parent.width * 0.5)

        overline: root.shownRail
        title: root.shownItem.title
        metadata: root.shownItem.artist ? [root.shownItem.artist] : [String(root.shownItem.year), root.shownItem.runtime, root.shownItem.genres]
        badges: root.shownItem.badges ?? []
        description: root.shownItem.synopsis ?? ""
        actionsVisible: !root.browsing

        BigscreenUI.Button {
            id: playButton
            focus: true
            text: "Play"
            icon.name: "media-playback-start"
            KeyNavigation.right: infoButton
            KeyNavigation.down: rails
            onClicked: console.log("HeroBanner: Play")
        }
        BigscreenUI.Button {
            id: infoButton
            text: "More info"
            icon.name: "documentinfo"
            KeyNavigation.down: rails
            onClicked: console.log("HeroBanner: More info")
        }
    }

    BigscreenUI.RailView {
        id: rails

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        // The rail view fades rails out in its top margin, above the current rail
        anchors.topMargin: restingY - topMargin
        // As tall as the page, so it still reaches the bottom when moved up to the banner
        height: parent.height

        // Where the rails sit before the transform moves them to the banner
        readonly property real restingY: Math.round(parent.height * 0.52)

        // Follow the banner, whose height depends on its text: below its actions, or in their
        // place while browsing. A transform keeps the view's size fixed. Only the move between
        // the two is animated, so the rails don't slide around as the page is first laid out.
        property real browseProgress: root.browsing ? 1 : 0
        Behavior on browseProgress {
            NumberAnimation {
                duration: Kirigami.Units.longDuration * 1.5
                easing.type: Easing.InOutCubic
            }
        }

        transform: Translate {
            readonly property real belowActions: hero.height + Kirigami.Units.gridUnit * 2
            y: hero.y + belowActions + (hero.actionRow.y - belowActions) * rails.browseProgress
               - rails.restingY
        }

        Keys.priority: Keys.AfterItem
        Keys.onUpPressed: playButton.forceActiveFocus()

        BigscreenUI.ContentRail {
            id: continueRail
            title: "Landscape cards with progress"
            model: Artwork.movies.slice(0, 5)
            delegate: BigscreenUI.MediaCard {
                required property var modelData
                required property int index
                artworkWidth: Kirigami.Units.gridUnit * 22
                artworkHeight: artworkWidth * 9 / 16
                source: modelData.image
                text: modelData.title
                subtitle: "%1 min left".arg(20 + index * 13)
                progress: [0.62, 0.31, 0.85, 0.12, 0.45][index]
                onActiveFocusChanged: if (activeFocus) root.show(modelData, continueRail.title)
                onClicked: console.log("MediaCard: %1".arg(modelData.title))
            }
        }

        BigscreenUI.ContentRail {
            id: posterRail
            title: "Poster cards"
            model: Artwork.movies
            delegate: BigscreenUI.MediaCard {
                required property var modelData
                artworkWidth: Kirigami.Units.gridUnit * 12
                source: modelData.image
                text: modelData.title
                onActiveFocusChanged: if (activeFocus) root.show(modelData, posterRail.title)
                onClicked: console.log("MediaCard: %1".arg(modelData.title))
            }
        }

        BigscreenUI.ContentRail {
            id: episodeRail
            title: "Watched marks"
            model: 6
            delegate: BigscreenUI.MediaCard {
                required property int index
                readonly property var series: Artwork.movies[5]
                artworkWidth: Kirigami.Units.gridUnit * 20
                artworkHeight: artworkWidth * 9 / 16
                source: Artwork.movies[index % Artwork.movies.length].image
                text: "Episode %1".arg(index + 1)
                subtitle: index < 3 ? "Watched" : "%1 min".arg(42 + index)
                watched: index < 3
                progress: index === 3 ? 0.4 : -1
                onActiveFocusChanged: if (activeFocus) root.show(series, episodeRail.title)
                onClicked: console.log("MediaCard: Episode %1".arg(index + 1))
            }
        }

        BigscreenUI.ContentRail {
            id: albumRail
            title: "Square cards"
            model: Artwork.albums
            delegate: BigscreenUI.MediaCard {
                required property var modelData
                artworkWidth: Kirigami.Units.gridUnit * 14
                artworkHeight: artworkWidth
                source: modelData.image
                text: modelData.title
                subtitle: modelData.artist
                onActiveFocusChanged: if (activeFocus) root.show(modelData, albumRail.title)
                onClicked: console.log("MediaCard: %1".arg(modelData.title))
            }
        }
    }
}

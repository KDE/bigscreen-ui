// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Templates as T

import org.kde.kirigami as Kirigami
import org.kde.bigscreen.ui as BigscreenUI

// A featured banner and rails of MediaCards.
BigscreenUI.Page {
    id: root

    readonly property var featured: Artwork.movies[0]
    readonly property url backdropSource: rails.currentIndex > 0 ? rails.currentItem?.currentItem?.source ?? "" : featured.image

    function openDetails(item: var, rail: string): void {
        T.ApplicationWindow.window.pageStack.push(detailsPage, { item: item, rail: rail });
    }

    background: BigscreenUI.BackdropImage {
        source: root.backdropSource
    }

    BigscreenUI.RailView {
        id: rails

        anchors.fill: parent
        anchors.topMargin: root.contentMargins.top - topMargin
        bottomMargin: root.contentMargins.bottom
        focus: true

        FocusScope {
            implicitHeight: hero.implicitHeight

            BigscreenUI.HeroBanner {
                id: hero

                x: root.contentMargins.left
                width: Math.round(parent.width * 0.5)

                overline: "Featured"
                title: root.featured.title
                metadata: [String(root.featured.year), root.featured.runtime, root.featured.genres]
                badges: root.featured.badges
                description: root.featured.synopsis

                BigscreenUI.Button {
                    focus: true
                    text: "Play"
                    icon.name: "media-playback-start"
                    onClicked: console.log("HeroBanner: Play")
                }
                BigscreenUI.Button {
                    text: "More info"
                    icon.name: "documentinfo"
                    onClicked: root.openDetails(root.featured, "Featured")
                }
            }
        }

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
                onClicked: root.openDetails(modelData, continueRail.title)
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
                onClicked: root.openDetails(modelData, posterRail.title)
            }
        }

        ExpandingRail {
            title: "Details that open inline"
            model: Artwork.movies
            onMoreInfoRequested: movie => root.openDetails(movie, title)
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
                onClicked: root.openDetails(series, episodeRail.title)
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
                onClicked: root.openDetails(modelData, albumRail.title)
            }
        }
    }

    Component {
        id: detailsPage

        DetailsPage {
            id: details

            required property var item
            required property string rail

            source: item.image
            overline: rail
            title: item.title
            metadata: item.artist ? [item.artist] : [String(item.year), item.runtime, item.genres]
            badges: item.badges ?? []
            description: item.synopsis ?? ""

            BigscreenUI.Button {
                focus: true
                text: "Play"
                icon.name: "media-playback-start"
                onClicked: console.log("DetailsPage: Play %1".arg(details.item.title))
            }
            BigscreenUI.Button {
                text: "Add to watchlist"
                icon.name: "list-add"
                onClicked: console.log("DetailsPage: Add %1 to watchlist".arg(details.item.title))
            }
        }
    }
}

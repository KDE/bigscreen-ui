// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.bigscreen.ui as BigscreenUI

// MediaGrid of a library, filtered with a ChipBar, and a PlaceholderMessage when it is empty
BigscreenUI.Page {
    id: root

    // Folders first, then every movie a few times over, so the grid scrolls
    readonly property var library: [
        { title: "Holidays", subtitle: "Folder", folder: true },
        { title: "Concerts", subtitle: "Folder", folder: true },
        ...[0, 1, 2].reduce((items, round) => items.concat(Artwork.movies.map(movie => ({
            title: movie.title,
            subtitle: "%1 · %2".arg(movie.year).arg(movie.runtime),
            image: movie.image,
            progress: round === 0 ? 0.3 : -1
        }))), [])
    ]

    readonly property var filters: ["All", "Folders", "Videos", "Empty"]

    readonly property var shown: {
        switch (chips.selectedIndex) {
        case 1: return library.filter(item => item.folder);
        case 2: return library.filter(item => !item.folder);
        case 3: return [];
        default: return library;
        }
    }

    title: "Grid"
    background: BigscreenUI.AmbientBackground {}

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        BigscreenUI.ChipBar {
            id: chips

            Layout.fillWidth: true
            Layout.leftMargin: root.contentMargins.left
            Layout.rightMargin: root.contentMargins.right
            Layout.topMargin: Kirigami.Units.gridUnit

            focus: true
            model: root.filters
            KeyNavigation.down: grid.count > 0 ? grid : placeholder
        }

        BigscreenUI.MediaGrid {
            id: grid

            Layout.fillWidth: true
            Layout.fillHeight: true

            visible: count > 0
            model: root.shown
            // Up from the top row
            KeyNavigation.priority: KeyNavigation.AfterItem
            KeyNavigation.up: chips

            delegate: BigscreenUI.MediaCard {
                required property var modelData

                artworkWidth: GridView.view.cardWidth
                artworkHeight: GridView.view.artworkHeight
                source: modelData.image ?? ""
                placeholderIconName: modelData.folder ? "folder" : "video-x-generic"
                text: modelData.title
                subtitle: modelData.subtitle
                progress: modelData.progress ?? -1
                onClicked: console.log("MediaGrid: %1".arg(modelData.title))
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: grid.count === 0

            BigscreenUI.PlaceholderMessage {
                id: placeholder

                anchors.centerIn: parent
                width: Math.min(parent.width - BigscreenUI.Units.horizontalScreenMargin * 2, implicitWidth)

                iconName: "folder-videos"
                text: "Nothing here yet"
                explanation: "PlaceholderMessage fills in for content that is empty or failed to load, with an optional action to fix it."
                helpfulAction: Kirigami.Action {
                    text: "Show everything"
                    icon.name: "view-list-icons"
                    onTriggered: {
                        chips.selectedIndex = 0;
                        chips.forceActiveFocus();
                    }
                }
                KeyNavigation.up: chips
            }
        }
    }
}

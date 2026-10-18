// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.bigscreen.ui as BigscreenUI

BigscreenUI.ScrollablePage {
    id: root

    title: "Controls"
    background: BigscreenUI.AmbientBackground {}

    ColumnLayout {
        spacing: Kirigami.Units.gridUnit * 3

        GallerySection {
            title: "Buttons"
            description: "Button is for actions with a label. RoundButton is for icon-only controls."

            RowLayout {
                spacing: Kirigami.Units.largeSpacing * 2

                BigscreenUI.Button {
                    id: playButton
                    focus: true
                    text: "Play"
                    icon.name: "media-playback-start"
                    KeyNavigation.right: infoButton
                    KeyNavigation.down: genres
                    onClicked: console.log("Button: Play")
                }
                BigscreenUI.Button {
                    id: infoButton
                    text: "More info"
                    icon.name: "documentinfo"
                    KeyNavigation.right: addButton
                    KeyNavigation.down: genres
                    onClicked: console.log("Button: More info")
                }
                BigscreenUI.Button {
                    id: addButton
                    icon.name: "list-add"
                    KeyNavigation.right: flatButton
                    KeyNavigation.down: genres
                    Accessible.name: "Add to list"
                    onClicked: console.log("Button: Add to list")
                }
                BigscreenUI.Button {
                    id: flatButton
                    text: "Flat button"
                    flat: true
                    KeyNavigation.right: backButton
                    KeyNavigation.down: genres
                    onClicked: console.log("Button: Flat button")
                }

                Item {
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 2
                }

                BigscreenUI.RoundButton {
                    id: backButton
                    text: "Back"
                    icon.name: "media-seek-backward"
                    KeyNavigation.right: roundPlayButton
                    KeyNavigation.down: genres
                    onClicked: console.log("RoundButton: Back")
                }
                BigscreenUI.RoundButton {
                    id: roundPlayButton
                    text: "Play"
                    icon.name: "media-playback-start"
                    KeyNavigation.right: forwardButton
                    KeyNavigation.down: genres
                    icon.width: Kirigami.Units.iconSizes.large
                    icon.height: Kirigami.Units.iconSizes.large
                    onClicked: console.log("RoundButton: Play")
                }
                BigscreenUI.RoundButton {
                    id: forwardButton
                    text: "Forward"
                    icon.name: "media-seek-forward"
                    KeyNavigation.down: genres
                    onClicked: console.log("RoundButton: Forward")
                }
            }
        }

        GallerySection {
            title: "Chips"
            description: "ChipBar keeps one chip selected, for filters such as genres or seasons. A Chip can also be used on its own as a toggle."

            BigscreenUI.ChipBar {
                id: genres
                Layout.fillWidth: true
                KeyNavigation.up: playButton
                KeyNavigation.down: hdChip
                model: ["All", "Drama", "Comedy", "Documentary", "Sci-fi", "Animation"]
                onActivated: index => console.log("ChipBar: %1".arg(model[index]))
            }

            RowLayout {
                spacing: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing

                BigscreenUI.Chip {
                    id: hdChip
                    text: "4K only"
                    KeyNavigation.up: genres
                    KeyNavigation.right: unwatchedChip
                    KeyNavigation.down: searchField
                    checkable: true
                    onToggled: console.log(checked ? "Chip: 4K only on" : "Chip: 4K only off")
                }
                BigscreenUI.Chip {
                    id: unwatchedChip
                    text: "Unwatched"
                    KeyNavigation.up: genres
                    KeyNavigation.down: searchField
                    checkable: true
                    checked: true
                    onToggled: console.log(checked ? "Chip: Unwatched on" : "Chip: Unwatched off")
                }
            }
        }

        GallerySection {
            title: "Text field"
            description: "Typing works as soon as the field has focus."

            BigscreenUI.TextField {
                id: searchField
                KeyNavigation.up: hdChip
                KeyNavigation.down: seekBar
                Layout.preferredWidth: Kirigami.Units.gridUnit * 40
                placeholderText: "Search movies, shows and music"
                onTextEdited: console.log("TextField: “%1”".arg(text))
            }
        }

        GallerySection {
            title: "Type scale"
            description: "Set a Label's type to use these styles. Large text uses a light weight."

            Repeater {
                model: [
                    { name: "Display", type: BigscreenUI.Label.Display },
                    { name: "Title", type: BigscreenUI.Label.Title },
                    { name: "Section", type: BigscreenUI.Label.Section },
                    { name: "Heading", type: BigscreenUI.Label.Heading },
                    { name: "Body", type: BigscreenUI.Label.Body },
                    { name: "Small", type: BigscreenUI.Label.Small }
                ]
                delegate: RowLayout {
                    required property var modelData
                    spacing: Kirigami.Units.gridUnit

                    BigscreenUI.Label {
                        Layout.preferredWidth: Kirigami.Units.gridUnit * 8
                        text: "%1 px".arg(sample.font.pixelSize)
                        color: Kirigami.Theme.disabledTextColor
                        font.features: ({ "tnum": 1 })
                    }
                    BigscreenUI.Label {
                        id: sample
                        text: "Label.%1".arg(modelData.name)
                        type: modelData.type
                    }
                }
            }
        }

        GallerySection {
            title: "Badges"
            description: "Short metadata shown next to a title."

            RowLayout {
                spacing: Kirigami.Units.largeSpacing
                BigscreenUI.Badge { text: "4K HDR" }
                BigscreenUI.Badge { text: "Dolby Atmos" }
                BigscreenUI.Badge { text: "CC" }
                BigscreenUI.Badge { text: "16+" }
            }
        }

        GallerySection {
            title: "Progress and seeking"
            description: "ProgressBar shows how far along something is. SeekBar is the focusable version: left and right move by its step size."

            GridLayout {
                columns: 2
                columnSpacing: Kirigami.Units.gridUnit * 2
                rowSpacing: Kirigami.Units.gridUnit

                BigscreenUI.Label {
                    text: "ProgressBar"
                    color: Kirigami.Theme.disabledTextColor
                }
                BigscreenUI.ProgressBar {
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 30
                    value: 0.62
                }

                BigscreenUI.Label {
                    text: "SeekBar - %1%".arg(Math.round(seekBar.value))
                    color: Kirigami.Theme.disabledTextColor
                    font.features: ({ "tnum": 1 })
                }
                BigscreenUI.SeekBar {
                    id: seekBar
                    KeyNavigation.up: searchField
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 30
                    from: 0
                    to: 100
                    stepSize: 5
                    value: 35
                }
            }
        }

        GallerySection {
            title: "Busy indicator"

            BigscreenUI.BusyIndicator {}
        }
    }
}

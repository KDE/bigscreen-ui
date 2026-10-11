// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T

import org.kde.kirigami as Kirigami
import org.kde.bigscreen.ui as BigscreenUI

BigscreenUI.ScrollablePage {
    id: root

    title: "Lists"
    background: BigscreenUI.BackdropImage {
        source: "qrc:/images/shell.jpg"
    }

    ColumnLayout {
        spacing: Kirigami.Units.gridUnit * 3

        GallerySection {
            title: "List delegates"
            description: "Rows for settings and menus. Each takes an icon, a description, and optional leading and trailing items."

            ColumnLayout {
                Layout.fillWidth: true
                Layout.maximumWidth: Kirigami.Units.gridUnit * 60
                spacing: Kirigami.Units.smallSpacing

                BigscreenUI.ButtonDelegate {
                    id: buttonDelegate
                    focus: true
                    text: "ButtonDelegate"
                    description: "Runs an action, here with a trailing arrow"
                    icon.name: "applications-graphics"
                    trailing: Kirigami.Icon {
                        source: "go-next"
                        implicitWidth: Kirigami.Units.iconSizes.small
                        implicitHeight: Kirigami.Units.iconSizes.small
                    }
                    KeyNavigation.down: switchDelegate
                    onClicked: console.log("ButtonDelegate activated")
                }

                BigscreenUI.SwitchDelegate {
                    id: switchDelegate
                    text: "SwitchDelegate"
                    KeyNavigation.up: buttonDelegate
                    KeyNavigation.down: comboBoxDelegate
                    description: checked ? "On" : "Off"
                    icon.name: "preferences-system"
                    checked: true
                    onToggled: console.log(checked ? "SwitchDelegate on" : "SwitchDelegate off")
                }

                BigscreenUI.ComboBoxDelegate {
                    id: comboBoxDelegate
                    text: "ComboBoxDelegate"
                    KeyNavigation.up: switchDelegate
                    KeyNavigation.down: customDelegate
                    icon.name: "view-list-details"
                    model: ["Small", "Medium", "Large", "Extra large"]
                    currentIndex: 1
                    onActivated: index => console.log("ComboBoxDelegate: %1".arg(model[index]))
                }

                BigscreenUI.TextDelegate {
                    text: "TextDelegate"
                    description: "Information only. It can't take focus, so the arrow keys skip it."
                    icon.name: "dialog-information"
                }

                BigscreenUI.ItemDelegate {
                    id: customDelegate
                    KeyNavigation.up: comboBoxDelegate
                    KeyNavigation.down: raisedSample
                    text: "ItemDelegate with custom content"
                    contentItem: BigscreenUI.Label {
                        text: customDelegate.text
                        horizontalAlignment: Text.AlignHCenter
                    }
                    onClicked: console.log("ItemDelegate activated")
                }
            }
        }

        GallerySection {
            title: "DelegateBackground"
            description: "The background all of the controls share. Use it to give custom controls the same raised look and focus style."

            RowLayout {
                spacing: Kirigami.Units.gridUnit

                BackgroundSample {
                    id: raisedSample
                    KeyNavigation.up: customDelegate
                    text: "Raised"
                    KeyNavigation.right: alternateSample
                }
                BackgroundSample {
                    id: alternateSample
                    KeyNavigation.up: customDelegate
                    text: "Alternate color"
                    alternate: true
                    KeyNavigation.right: flatSample
                }
                BackgroundSample {
                    id: flatSample
                    KeyNavigation.up: customDelegate
                    text: "Flat"
                    raised: false
                    KeyNavigation.right: checkedSample
                }
                BackgroundSample {
                    id: checkedSample
                    KeyNavigation.up: customDelegate
                    text: "Checked"
                    checked: true
                }
            }
        }
    }

    component BackgroundSample: T.Control {
        id: sample

        property string text
        property bool alternate: false
        property bool raised: true
        property bool checked: false

        implicitWidth: Kirigami.Units.gridUnit * 12
        implicitHeight: Kirigami.Units.gridUnit * 5
        focusPolicy: Qt.StrongFocus
        hoverEnabled: true

        contentItem: BigscreenUI.Label {
            text: sample.text
            horizontalAlignment: Text.AlignHCenter
        }

        background: BigscreenUI.DelegateBackground {
            control: sample
            alternateBackgroundColor: sample.alternate
            raisedBackground: sample.raised
            checked: sample.checked
        }

        TapHandler {
            onTapped: sample.forceActiveFocus()
        }
    }
}
